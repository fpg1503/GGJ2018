extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Tutorial.connect("pressed", self, "_tutorial_pressed")

func _tutorial_pressed():
	pass
