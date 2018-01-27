extends Control

enum GAME_STATE {SETTING_UP, PLAYING, CREATING, TESTING}

onready var current_stage = 0
onready var state = GAME_STATE.SETTING_UP setget set_state
onready var won = false
onready var map_id = null

func set_state(new_state):
	if (new_state == CREATING):
		$Hud.enter()
	state = new_state

func _on_won():
	set_state(GAME_STATE.CREATING)

func _on_lost():
	set_state(GAME_STATE.CREATING)

func _ready():
	set_process_input(true)
	$Grid.connect("won", self, "_on_won")
	$Grid.connect("lost", self, "_on_lost")
	
#	$Grid.set_grid("stage1")
#	$Grid.start_game()
	
#	Server.fetch_levels()
	Server.fetch_level(1)
	Server.connect('level_fetched', self, 'level_fetched')
	
	state = GAME_STATE.PLAYING

func level_fetched(level, grid_info, map_id):
	print('Successfully fetched level ' + str(level))
	self.map_id = map_id
	for item in grid_info:
		var x = item['x']
		var y = item['y']
		var type = item['type']
		if global.ACTORS.has(type):
			var element = global.ACTORS[type].instance()
			element.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
			element.z_index = y*10
			$Grid.add_child(element)
			$Grid.gridmap[Vector2(x,y)] = element
			element.grid_pos = Vector2(x,y)
			if type == 'Player':
				element.position = Vector2(x*global.TILE_SIZE.x, -500)
				element.z_index += 1
				element.falling = true
				$Grid.player = element
				$Grid.starting_y = y*global.TILE_SIZE.y
		else:
			print('Unsupoorted element: ' + type)

	$Grid.player.connect("move", self, "_on_player_move")
	$Grid.start_game()
	
func sendGridToServer():
	var map = []
	for child in $Grid.get_children():
		var position = child.get_position()
		var x = position.x / global.TILE_SIZE.x
		var y = position.y / global.TILE_SIZE.y
		if child.has_method('get_type'):
			map.append({'x': x, 'y': y, 'type': child.get_type()})
			
	Server.save_level(1, map, 'test_user', map_id)
	
func _input(event):
	if event.as_text() == 'S' and event.is_pressed() and not event.is_echo():
		print('Sending to server!')
		sendGridToServer()