extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$BackButton.connect("pressed", self, "_on_back_pressed")

func _on_back_pressed():
	global.scene_manager.change_scene("MainMenu")

func update_tables(table):
	var i = 0
	for e in table:
		$Table/EnemySpyColumn.get_child(i).text = e[0]
		$Table/SabotagesColumn.get_child(i).text = e[1]
		i += 1