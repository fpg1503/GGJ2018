extends Node2D

func _ready():
	$PawButton.connect("pressed", self, "_open")

func _open():
	$AnimationPlayer.play("open")
