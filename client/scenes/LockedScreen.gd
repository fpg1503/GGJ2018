extends Node2D

func _ready():
	$PawButton.connect("pressed", self, "_open")

func _open():
	if( not $AnimationPlayer.is_playing()):
		$AnimationPlayer.play("open")
