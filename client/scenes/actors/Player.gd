extends "Actor.gd"

signal move

enum MOVE_DIR {UP, RIGHT, DOWN, LEFT}

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

func _on_animation_finished(name):
	if (name == "won"):
		get_parent().emit_signal("won")
	elif (name == "lost"):
		end = true
		get_parent().emit_signal("lost")

func _on_destroyed():
	$AnimationPlayer.play("lost")

func _ready():
	add_child(tweenIntro)
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	
	swipe.connect("swipe", self, "_on_swipe")
	
	type = "Player"
	
	tweenIntro.connect("tween_completed", self, "_child_on_tween_completed")
	tween.connect("tween_completed", self, "_movement_completed")
	connect("destroyed", self, "_on_destroyed")
	set_process_input(true)

###REFACTOR
# repeated code on _on_swipe and _input for movement
func _move(dir):
	if dir == UP:
		emit_signal("move", Vector2(0,-1))
	elif dir == DOWN:
		emit_signal("move", Vector2(0,1))
	elif dir == LEFT:
		emit_signal("move", Vector2(-1,0))
		if(left):
			left = false
			$Sprite.scale.x *= -1
	elif dir == RIGHT:
		emit_signal("move", Vector2(1,0))
		if(not left):
			left = true
			$Sprite.scale.x *= -1

func _on_swipe(dir):
	if (falling or raising or won):
		return
	if(not is_destroyed):
		if (dir == "left"):
			_move(LEFT)
		if (dir == "right"):
			_move(RIGHT)
		if (dir == "up"):
			_move(UP)
		if (dir == "down"):
			_move(DOWN)

func _input(event):
	if (event is InputEventKey and event.scancode == KEY_K):
		.destroy()
	
	if (falling or raising or won):
		return
	if(not is_destroyed):
		if (event.is_action("ui_left") and event.is_pressed() and !event.is_echo()):
			_move(LEFT)
		if (event.is_action("ui_right") and event.is_pressed() and !event.is_echo()):
			_move(RIGHT)
		if (event.is_action("ui_up") and event.is_pressed() and !event.is_echo()):
			_move(UP)
		if (event.is_action("ui_down") and event.is_pressed() and !event.is_echo()):
			_move(DOWN)