extends "Actor.gd"

func on_destroyed():
	$AnimationPlayer.play("destroyed")

func _ready():
	type = "Stone"
	movable = false
	connect("destroyed", self, "on_destroyed")