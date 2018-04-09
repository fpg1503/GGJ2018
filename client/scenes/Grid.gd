extends Node2D

const Z_INDEX_FIX = 500

onready var player = null
onready var gridmap = {}

onready var traps = {}
onready var starting_y = 0

signal won
signal lost
signal deleted

func kill_player():
	player.destroy()

func start_game():
	player.fall(starting_y)

func reset_grid():
	for key in gridmap.keys():
		gridmap[key].queue_free()
	for key in traps.keys():
		traps[key].queue_free()
	gridmap.clear()
	traps.clear()

func insert(type, x, y):
	if (x < 0 or x >= global.MAP_SIZE.x or y < 0 or y > global.MAP_SIZE.y):
		return false
	
	if global.ACTORS.has(type):
		if gridmap.has(Vector2(x, y)) or traps.has(Vector2(x, y)):
			return false
		var dic_to_add = traps if type == 'Trap' or type == 'Trapdoor' else gridmap
		var element = global.ACTORS[type].instance()
		element.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
		element.z_index = y*10 + 1 - Z_INDEX_FIX
		add_child(element)
		dic_to_add[Vector2(x,y)] = element
		element.grid_pos = Vector2(x,y)
		if type == 'Player':
			element.position = Vector2(x*global.TILE_SIZE.x, - Z_INDEX_FIX)
			element.z_index += 1
			element.falling = true
			player = element
			starting_y = y*global.TILE_SIZE.y
			element.connect("move", self, "_on_player_move")
		if type == 'Trap':
			element.add_to_group('traps')
			element.z_index += 2
		return true
	elif len(type) > 0:
		print('Unsupported element: ' + type + '(' + str(x) + ',' + str(y) + ')')
		return false
	else:
		print('Attempted to deserialize unnamed type')
		return false

func set_grid(stage):
	reset_grid()
	
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

func used_smoke_bomb():
	var pos = player.grid_pos
	
	for x in range(pos.x-1,pos.x+2):
		for y in range(pos.y-1, pos.y+2):
			var p = Vector2(x,y)
			if (traps.has(p) and traps[p].type == "Trap" and traps[p].active):
				traps[p].deactivate()

func _on_player_move(vec2):
	var from = player.grid_pos
	var to = from + vec2
	
	if (to.x < 0 or to.x >= global.MAP_SIZE.x or to.y < 0 or to.y >= global.MAP_SIZE.y):
		return
	
	if (gridmap.has(to)):
		if (check_movable(from, to)):
			# africa by
			var toto = to + (to - from) 
			gridmap[to].z_index = toto.y * 10 - Z_INDEX_FIX
			gridmap[to].move_to_tile(toto)
			gridmap[toto] = gridmap[to]
			gridmap.erase(to)
			if (traps.has(toto)):
				traps[toto].deactivate()
		else:
			return
	
	gridmap.erase(from)
	gridmap[to] = player
	player.z_index = to.y * 10 + 2 - Z_INDEX_FIX
	player.move_to_tile(to)
	
	if (traps.has(to) and traps[to].type == "Trap" and traps[to].active):
		player.destroy()
		traps[to].deactivate()
	elif (traps.has(to) and traps[to].type == "Trapdoor"):
		player.won = true
	else:
		# Check how many traps there are around the player
		var number_traps = _check_traps_around(to)
		if number_traps > 0:
			player.show_ballon(number_traps)
		else:
			player.hide_ballon()

func _check_traps_around(pos):
	var number_traps = 0
	for x in range(pos.x-1,pos.x+2):
		for y in range(pos.y-1, pos.y+2):
			var p = Vector2(x,y)
			if (traps.has(p) and traps[p].type == "Trap" and traps[p].active):
				number_traps+=1
	return number_traps

func _ready():
	pass
