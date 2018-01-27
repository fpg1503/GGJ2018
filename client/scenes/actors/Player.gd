extends "Actor.gd"

signal move

onready var tweenIntro = Tween.new()
onready var falling = false
onready var raising = false
onready var left = true

func fall(y):
	invencible = true
	falling = true
	rotation_degrees = -30
	tweenIntro.interpolate_property(self, "rotation_degrees", rotation_degrees, 0, 2, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	tweenIntro.interpolate_property(self, "position", position, Vector2(position.x, y), 2,Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	tweenIntro.start()

func _on_tween_completed(obj, prop):
	invencible = false
	falling = false
	raising = false

func _on_destroyed():
	get_parent().emit_signal("lost")

func _ready():
	add_child(tweenIntro)
	
	type = "Player"
	$Face.texture = global.FACES[int(randf() * global.FACES.size())]
	
	tweenIntro.connect("tween_completed", self, "_on_tween_completed")
	connect("destroyed", self, "_on_destroyed")
	set_process_input(true)

func _input(event):
	if (falling or raising):
		return
	if(not is_destroyed):
		if (event.is_action("ui_left") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(-1,0))
			if(left):
				left = false
				scale.x = -1
		if (event.is_action("ui_right") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(1,0))
			if(not left):
				left = true
				scale.x = 1
		if (event.is_action("ui_up") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(0,-1))
		if (event.is_action("ui_down") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(0,1))