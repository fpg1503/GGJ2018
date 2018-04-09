extends Control

onready var is_open = false

signal used_smoke_bomb

func _ready():
	$Bag.connect("pressed", self, "_on_bag_pressed")
	$HBoxContainer/SmokeBomb.connect("pressed", self, "_on_item_pressed", ["smoke_bomb"])
	
	update_itens_label()
	
	$Bag.modulate = Color(1.0, 1.0, 1.0, 0.4)

func update_itens_label():
	$HBoxContainer/SmokeBomb/Label.text = str(global.player_data["itens"]["smoke_bomb"])

func _on_item_pressed(item):
	if (global.player_data["itens"][item]) <= 0:
		return
	emit_signal("used_" + str(item))
	global.player_data["itens"][item] -= 1
	update_itens_label()

func _on_bag_pressed():
	if not is_open:
		is_open = true
		$Bag.modulate = Color(1.0, 1.0, 1.0, 1.0)
		$HBoxContainer.show()
	else:
		is_open = false
		$Bag.modulate = Color(1.0, 1.0, 1.0, 0.4)
		$HBoxContainer.hide()
