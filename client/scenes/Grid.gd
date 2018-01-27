extends Node2D

onready var player = null
onready var gridmap = {}

func my_set_grid(grid_info):
	print(grid_info)
	for item in grid_info['map']:
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
	sendGridToServer()
	
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
	print('--------------')
	sendGridToServer()
	
	gridmap.erase(from)
	gridmap[to] = player
	player.z_index = to.y * 10 + 1
	player.move_to_tile(to)

func sendGridToServer():
	var regex = RegEx.new()
	regex.compile("\\/([^./]*)\\.tscn$")

	for child in get_children():
		var position = child.get_position()
		var x = position.x / global.TILE_SIZE.x
		var y = position.y / global.TILE_SIZE.y
		var filename = child.get_filename()
		var result = regex.search(filename)
		if result:
			print('{"x":'+str(x) + ',"y":' + str(y) + ',"type":"' + str(result.get_strings()[1]) + '"}')

func _ready():
	Server.connect('response', self, 'my_set_grid')
#	$Player.connect("move", self, "_on_player_move")
	pass
