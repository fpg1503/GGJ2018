extends "Actor.gd"

func on_destroyed():
	$AnimationPlayer.play("destroyed")

func _ready():
	type = "Box"
	movable = true
	connect("destroyed", self, "on_destroyed")