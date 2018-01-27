extends Node2D

onready var movable = false
onready var tween = Tween.new()
onready var grid_pos = Vector2(0,0)

func is_movable():
	return movable

func move_to_tile(vec2):
	grid_pos = vec2
	var target_pos = Vector2(grid_pos.x*global.TILE_SIZE.x, grid_pos.y*global.TILE_SIZE.y)
	tween.interpolate_property(self, "position", position, target_pos, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _ready():
	add_child(tween)