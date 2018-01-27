extends "Actor.gd"

signal move

func _ready():
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