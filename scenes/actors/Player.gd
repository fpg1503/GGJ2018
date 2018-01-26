extends Node2D

signal move

onready var tween = Tween.new()
onready var target_pos = position

func move_to(vec2):
	target_pos = vec2
	tween.interpolate_property(self, "position", position, target_pos, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _ready():
	add_child(tween)
	
	set_process_input(true)

func _input(event):
	if (event.is_action("ui_left") and event.is_pressed() and !event.is_echo()):
		emit_signal("move", Vector2(-1,0))
	if (event.is_action("ui_right") and event.is_pressed() and !event.is_echo()):
		emit_signal("move", Vector2(1,0))
	if (event.is_action("ui_up") and event.is_pressed() and !event.is_echo()):
		emit_signal("move", Vector2(0,-1))
	if (event.is_action("ui_down") and event.is_pressed() and !event.is_echo()):
		emit_signal("move", Vector2(0,1))