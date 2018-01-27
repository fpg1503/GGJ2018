extends Node2D

onready var player = null
onready var gridmap = {}
var map_id = ''
onready var traps = {}

func set_grid(stage):
	var grid = global.STAGES[stage].instance()
	print(grid)
	var ts = grid.tile_set
	
	for x in range(global.MAP_SIZE.x):
		for y in range(global.MAP_SIZE.y):
			var cell = grid.get_cell(x, y)
			if (cell > -1):
				var name = ts.tile_get_name(cell)
				if (name == "Box"):
					var box = global.ACTORS["Box"].instance()
					box.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
					box.z_index = y*10
					add_child(box)
					gridmap[Vector2(x,y)] = box
					box.grid_pos = Vector2(x,y)
				if (name == "Stone"):
					var stone = global.ACTORS["Stone"].instance()
					stone.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
					stone.z_index = y*10
					add_child(stone)
					gridmap[Vector2(x,y)] = stone
					stone.grid_pos = Vector2(x,y)
				if (name == "Player"):
					player = global.ACTORS["Player"].instance()
					player.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
					player.z_index = y*10 + 1
					add_child(player)
					gridmap[Vector2(x,y)] = player
					player.grid_pos = Vector2(x,y)
				if (name == "Turret"):
					var turret = global.ACTORS["Turret"].instance()
					turret.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
					turret.z_index = y*10
					add_child(turret)
					gridmap[Vector2(x,y)] = turret
					turret.grid_pos = Vector2(x,y)
				if (name == "Trap"):
					var trap = global.ACTORS["Trap"].instance()
					trap.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
					trap.z_index = y*10
					add_child(trap)
					traps[Vector2(x,y)] = trap
					trap.grid_pos = Vector2(x,y)
	player.connect("move", self, "_on_player_move")

func level_fetched(level, grid_info, map_id):
	print('Successfully fetched level ' + str(level))
	self.map_id = map_id
	for item in grid_info:
		var x = item['x']
		var y = item['y']
		if (item['type'] == "Box"):
			var box = global.ACTORS["Box"].instance()
			box.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
			box.z_index = y * 10
			add_child(box)
			gridmap[Vector2(x,y)] = box
			box.grid_pos = Vector2(x,y)
		if (item['type'] == "Player"):
			player = global.ACTORS["Player"].instance()
			player.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
			player.z_index = y * 10 + 1
			add_child(player)
			gridmap[Vector2(x,y)] = player
			player.grid_pos = Vector2(x,y)
	player.connect("move", self, "_on_player_move")
	
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

func sendGridToServer():
	var regex = RegEx.new()
	regex.compile("\\/([^./]*)\\.tscn$")

	var map = []
	for child in get_children():
		var position = child.get_position()
		var x = position.x / global.TILE_SIZE.x
		var y = position.y / global.TILE_SIZE.y
		var filename = child.get_filename()
		var result = regex.search(filename)
		if result:
			var type = result.get_strings()[1]
			map.append({'x': x, 'y': y, 'type': type})
			
	Server.save_level(1, map, 'test_user', map_id)

func _ready():
	Server.connect('level_fetched', self, 'level_fetched')
	set_process_input(true)
#	Server.connect('response', self, 'my_set_grid')
#	$Player.connect("move", self, "_on_player_move")
	pass
	
func _input(event):
	if event.as_text() == 'S' and event.is_pressed() and not event.is_echo():
		print('Sending to server!')
		sendGridToServer()