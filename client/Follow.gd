extends Sprite

onready var active = false

signal place_item

func follow_mouse():
	active = true

func _ready():
	set_process(true)
	set_process_input(true)
	pass

func _input(event):
	if not active:
		return
	var left = InputEventMouseButton.new()
	left.button_index = BUTTON_LEFT
	if (event.action_match(left) and not event.is_pressed()): 
		active = false
		var tile_location = position / global.TILE_SIZE
		var tile_x = round(tile_location.x) - 1
		var tile_y = round(tile_location.y) - 2
		var tile = Vector2(tile_x, tile_y)
		emit_signal("place_item", tile)

		position = Vector2(-200, -200)
		

func _process(delta):
	if (active):
		var raw_position = get_viewport().get_mouse_position()
		var tile_location = raw_position / global.TILE_SIZE
		var tile_x = round(tile_location.x)
		var tile_y = round(tile_location.y)
		position = Vector2(tile_x * global.TILE_SIZE.x, tile_y * global.TILE_SIZE.y)
