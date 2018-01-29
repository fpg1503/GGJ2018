extends "Actor.gd"

func _ready():
	type = "Trapdoor"
	
	$Light2D.range_z_min += z_index
	$Light2D.range_z_max += z_index
	pass