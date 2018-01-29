extends "Actor.gd"

func on_destroyed():
	$AnimationPlayer.play("destroyed")

func _ready():
	type = "Trap"
	connect("destroyed", self, "on_destroyed")
