extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Tutorial.connect("pressed", self, "_tutorial_pressed")
	$Game.connect("pressed", self, "_game_pressed")
	$Shop.connect("pressed", self, "_shop_pressed")

func _tutorial_pressed():
	global.scene_manager.change_scene("Tutorial")

func _game_pressed():
	global.scene_manager.change_scene("Game")

func _shop_pressed():
	global.scene_manager.change_scene("Shop")
