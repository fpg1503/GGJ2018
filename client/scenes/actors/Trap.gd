extends "Actor.gd"

onready var active = true

func deactivate():
	$Sprite.texture = load("res://assets/broken alarm.png") #ugh
	$AnimationPlayer.play("deactivate")
	active = false

func on_destroyed():
	$AnimationPlayer.play("destroyed")

func _ready():
	type = "Trap"
	connect("destroyed", self, "on_destroyed")
