extends Control

enum GAME_STATE {SETTING_UP, PLAYING, CREATING, TESTING}

onready var current_stage = 0
onready var state = GAME_STATE.SETTING_UP setget set_state
onready var won = false
onready var map_id = null

onready var original_map = null
onready var current_map = null

func load_original_grid():
	current_map = original_map
	load_grid(current_map)

func load_grid(grid):
	$Grid.reset_grid()
	for item in grid:
		$Grid.insert(item.type, item.x, item.y)

func set_state(new_state):
	if (new_state == CREATING):
		$Hud.enter()
	
	if (state == PLAYING and new_state == CREATING):
		load_original_grid()
	elif (state == TESTING and new_state == CREATING):
		load_grid(current_map)
	
	state = new_state

func level_fetched(error, level, grid_info, map_id):
	print('Successfully fetched level ' + str(level))
	self.map_id = map_id
	original_map = grid_info
	load_original_grid()
	
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

func _on_won():
	set_state(GAME_STATE.CREATING)

func _on_lost():
	set_state(GAME_STATE.CREATING)

func _on_hud_play():
	$Grid.start_game()

func _on_hud_stop():
	$Grid.kill_player()
#	load_grid(current_map)

func _on_hud_shop():
	$Shop.enter()

func _on_hud_reset():
	load_original_grid()

func _ready():
	set_process_input(true)
	$Grid.connect("won", self, "_on_won")
	$Grid.connect("lost", self, "_on_lost")
	
	$Hud.connect("play", self, "_on_hud_play")
	$Hud.connect("stop", self, "_on_hud_stop")
	$Hud.connect("shop", self, "_on_hud_shop")
	$Hud.connect("reset", self, "_on_hud_reset")
	
	Server.fetch_level(1)
	Server.connect('level_fetched', self, 'level_fetched')
	
	state = GAME_STATE.PLAYING

func _input(event):
	if event.as_text() == 'S' and event.is_pressed() and not event.is_echo():
		print('Sending to server!')
		sendGridToServer()
