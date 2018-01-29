extends "Actor.gd"

func on_destroyed():
	$AnimationPlayer.play("destroyed")

func _ready():
	type = "Box"
	movable = true
	connect("destroyed", self, "on_destroyed")
	
func move_to_tile(vec2):
	.move_to_tile(vec2)
	$Player.play()

