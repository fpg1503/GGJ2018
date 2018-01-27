extends "Actor.gd"

signal move

func _on_destroyed():
	print("GAME OVER")

func _ready():
	type = "Player"
	$Face.texture = global.FACES[int(randf() * global.FACES.size())]
	
	connect("destroyed", self, "_on_destroyed")
	set_process_input(true)

func _input(event):
	if(not is_destroyed):
		if (event.is_action("ui_left") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(-1,0))
		if (event.is_action("ui_right") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(1,0))
		if (event.is_action("ui_up") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(0,-1))
		if (event.is_action("ui_down") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(0,1))