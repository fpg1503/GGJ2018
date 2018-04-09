extends Control

const PRICES = {
"smoke_bomb":4,
}

func buy(item):
	if global.player_data["gold"] >= PRICES[item]:
		global.player_data["gold"] -= PRICES[item]
		global.player_data["itens"][item] += 1
		global.save_player_data()
		
		$CurrentGold.text = "Current Gold: " + str(global.player_data["gold"])
		_update_quantity()

func _update_quantity():
	$Bomb/ItemQuantity.text = "Currently has: " + str(global.player_data["itens"]["smoke_bomb"])

func _ready():
	$CurrentGold.text = "Current Gold: " + str(global.player_data["gold"])
	$BackButton.connect("pressed", self, "_on_back_pressed")
	$Bomb/TextureButton.connect("pressed", self, "buy", ["smoke_bomb"])
	
	_update_quantity()

func _on_back_pressed():
	global.scene_manager.change_scene("MainMenu")
