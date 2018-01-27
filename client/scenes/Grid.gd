extends Node2D

onready var player = null
onready var gridmap = {}

func level_fetched(level, grid_info):
	print('Successfully fetched level ' + str(level))
	for item in grid_info:
		var x = item['x']
		var y = item['y']
		if (item['type'] == "Box"):
			var box = global.ACTORS["Box"].instance()
			box.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
			box.z_index = y
			add_child(box)
			gridmap[Vector2(x,y)] = box
			box.grid_pos = Vector2(x,y)
		if (item['type'] == "Player"):
			player = global.ACTORS["Player"].instance()
			player.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
			player.z_index = y
			add_child(player)
			gridmap[Vector2(x,y)] = player
			player.grid_pos = Vector2(x,y)
	player.connect("move", self, "_on_player_move")
	sendGridToServer()
	
func set_grid(stage):
	pass


func check_movable(from, to):
	var next = to - from
	if (gridmap[to].is_movable()):
		if (not gridmap.has(to + next)):
			return true
	return false

func _on_player_move(vec2):
	var from = player.grid_pos
	var to = from + vec2
	
	if (gridmap.has(to)):
		if (check_movable(from, to)):
			var toto = to + (to - from)
			gridmap[to].z_index = toto.y
			gridmap[to].move_to_tile(toto)
			gridmap[toto] = gridmap[to]
			gridmap.erase(to)
		else:
			return
	print('--------------')
	sendGridToServer()
	
	gridmap.erase(from)
	gridmap[to] = player
	player.z_index = to.y + 1
	player.move_to_tile(to)

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
			
	Server.save_level(1, map)

func _ready():
	Server.connect('level_fetched', self, 'level_fetched')
	pass