extends "Actor.gd"

func _ready():
	type = "Box"
	movable = true
	
func move_to_tile(vec2):
	.move_to_tile(vec2)
	$Player.play()