extends "Actor.gd"

signal move

onready var tweenIntro = Tween.new()
onready var falling = false
onready var raising = false
onready var left = true

onready var end = false
onready var won = false

func show_ballon(n):
	$TrapsBalloon.set_label_traps(n)
	$TrapsBalloon.appear()

func hide_ballon():
	if $TrapsBalloon.shown:
		$TrapsBalloon.disappear()

func fall(y):
	invencible = true
	falling = true
	rotation_degrees = -30
	tweenIntro.interpolate_property(self, "rotation_degrees", rotation_degrees, 0, 2, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	tweenIntro.interpolate_property(self, "position", position, Vector2(position.x, y), 2,Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	tweenIntro.start()

func _movement_completed(obj, prop):
	if (is_destroyed == false and won == true):
		raising = true
		$AnimationPlayer.play("won")

func _child_on_tween_completed(obj, prop):
	if (end):
		return
	invencible = false
	falling = false
	raising = false
	if(is_destroyed):
		end = true
		get_parent().emit_signal("lost")

func _on_animation_finished(name):
	if (name == "won"):
		get_parent().emit_signal("won")

func _on_destroyed():
	tweenIntro.interpolate_property($Sprite, "rotation_degrees", rotation_degrees, -90, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tweenIntro.interpolate_property(self, "position", position, Vector2(position.x, position.y + 30), 0.5, Tween.TRANS_ELASTIC,Tween.EASE_OUT_IN)
	tweenIntro.start()

func _ready():
	add_child(tweenIntro)
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	
	swipe.connect("swipe", self, "_on_swipe")
	
	type = "Player"
	$Sprite/Face.texture = global.FACES[int(randf() * global.FACES.size())]
	
	tweenIntro.connect("tween_completed", self, "_child_on_tween_completed")
	tween.connect("tween_completed", self, "_movement_completed")
	connect("destroyed", self, "_on_destroyed")
	set_process_input(true)

###REFACTOR
# repeated code on _on_swipe and _input for movement
func _on_swipe(dir):
	if (falling or raising):
		return
	if(not is_destroyed):
		if (dir == "left"):
			emit_signal("move", Vector2(-1,0))
			if(left):
				left = false
				$Sprite.scale.x *= -1
		if (dir == "right"):
			emit_signal("move", Vector2(1,0))
			if(not left):
				left = true
				$Sprite.scale.x *= -1
		if (dir == "up"):
			emit_signal("move", Vector2(0,-1))
		if (dir == "down"):
			emit_signal("move", Vector2(0,1))

func _input(event):
	if (falling or raising):
		return
	if(not is_destroyed):
		if (event.is_action("ui_left") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(-1,0))
			if(left):
				left = false
				$Sprite.scale.x *= -1
		if (event.is_action("ui_right") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(1,0))
			if(not left):
				left = true
				$Sprite.scale.x *= -1
		if (event.is_action("ui_up") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(0,-1))
		if (event.is_action("ui_down") and event.is_pressed() and !event.is_echo()):
			emit_signal("move", Vector2(0,1))