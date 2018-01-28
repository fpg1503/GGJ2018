extends Node

signal swipe
var swipe_start = null
var minimum_drag = 100

func _ready():
	set_process_input(true)

func _input(event):
	var touch = InputEventMouseButton.new()
	touch.button_index = BUTTON_LEFT
	if (event.action_match(touch) and event.is_pressed()): 
		swipe_start = get_viewport().get_mouse_position()
	if (event.action_match(touch) and not event.is_pressed()):
		_calculate_swipe(get_viewport().get_mouse_position())
        
func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	
	if abs(swipe.length()) > minimum_drag:
		if abs(swipe.angle_to(Vector2(0,1))) < PI/8:
			emit_signal("swipe", "down")
		elif abs(swipe.angle_to(Vector2(0,-1))) < PI/8:
			emit_signal("swipe", "up")
		elif abs(swipe.angle_to(Vector2(1,0))) < PI/8:
			emit_signal("swipe", "right")
		elif abs(swipe.angle_to(Vector2(-1,0))) < PI/8:
			emit_signal("swipe", "left")