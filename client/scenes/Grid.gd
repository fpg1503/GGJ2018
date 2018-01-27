extends Node2D

onready var player = null
onready var gridmap = {}

onready var traps = {}
onready var starting_y = 0

signal won
signal lost

func start_game():
	player.fall(starting_y)

func insert(type, x, y):
	if global.ACTORS.has(type):
		var element = global.ACTORS[type].instance()
		element.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
		element.z_index = y*10
		add_child(element)
		gridmap[Vector2(x,y)] = element
		element.grid_pos = Vector2(x,y)
		if type == 'Player':
			element.position = Vector2(x*global.TILE_SIZE.x, -500)
			element.z_index += 1
			element.falling = true
			player = element
			starting_y = y*global.TILE_SIZE.y
			element.connect("move", self, "_on_player_move")
	else:
		print('Unsupoorted element: ' + type)

func set_grid(stage):
	var grid = global.STAGES[stage].instance()
	print(grid)
	var ts = grid.tile_set
	
	for x in range(global.MAP_SIZE.x):
		for y in range(global.MAP_SIZE.y):
			var cell = grid.get_cell(x, y)
			if (cell > -1):
				var name = ts.tile_get_name(cell)
				insert(name, x, y)

	
func check_movable(from, to):
	var next = to + (to - from)
	if (next.x < 0 or next.x >= global.MAP_SIZE.x or next.y < 0 or next.y >= global.MAP_SIZE.y):
		return false
	if (gridmap[to].is_movable()):
		if (not gridmap.has(next)):
			return true
	return false

func _on_player_move(vec2):
	
	var from = player.grid_pos
	var to = from + vec2
	
	if (to.x < 0 or to.x >= global.MAP_SIZE.x or to.y < 0 or to.y >= global.MAP_SIZE.y):
		return
	
	if (gridmap.has(to)):
		if (check_movable(from, to)):
			var toto = to + (to - from) # africa by
			gridmap[to].z_index = toto.y * 10
			gridmap[to].move_to_tile(toto)
			gridmap[toto] = gridmap[to]
			gridmap.erase(to)
		else:
			return
	
	gridmap.erase(from)
	gridmap[to] = player
	player.z_index = to.y * 10 + 1
	player.move_to_tile(to)
	
	if (traps.has(to)):
		player.destroy()


func _ready():
	pass
