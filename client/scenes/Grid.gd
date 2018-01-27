extends Node2D

onready var player = null
onready var gridmap = {}

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
				if (name == "Player"):
					player = global.ACTORS["Player"].instance()
					player.position = Vector2(x*global.TILE_SIZE.x, y*global.TILE_SIZE.y)
					player.z_index = y*10 + 1
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

func _ready():
#	$Player.connect("move", self, "_on_player_move")
	pass
