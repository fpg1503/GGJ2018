extends Node2D

onready var shown = false

func set_label_traps(n):
	$Label.text = "= " + str(n)

func appear():
	$AnimationPlayer.play("appear")
	shown = true

func disappear():
	$AnimationPlayer.play_backwards("appear")
	shown = false

func _ready():
	pass