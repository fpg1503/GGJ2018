extends TextureRect

onready var tween = $Tween

signal shop
signal shop_back

enum Items { ITEM_BOX, ITEM_TRAP, ITEM_TURRET, ITEM_BOMB }
const ITEM_DETAILS = {
	ITEM_BOX: {
		'price': 5,
		'name': 'Box',
		'asset': preload("res://assets/tile/tile_crate.png")
	},
	ITEM_TRAP: {
		'price': 3,
		'name': 'Trap',
		'asset': preload("res://assets/tile/tile_trap.png")
	},
	ITEM_TURRET: {
		'price': 10,
		'name': 'Turret',
		'asset': preload("res://assets/tile/tile_gun.png")
	},
	ITEM_BOMB: {
		'price': 4,
		'name': 'Bomb',
		'asset': preload("res://assets/tile/tile_bomb.png")
	}
}

func get_price(item):
	return get_generic(item, 'price')

func get_name(item):
	return get_generic(item, 'name')
	
func get_asset(item):
	return get_generic(item, 'asset')
	
func get_generic(item, prop):
	return ITEM_DETAILS[item][prop]

func enter():
	tween.interpolate_property(self, "rect_position", rect_position, Vector2(rect_position.x, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	pass

func exit():
	tween.interpolate_property(self, "rect_position", rect_position, Vector2(rect_position.x, -rect_size.y), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	pass

func update_text():
	$LabelCoins.text = "Coins: " + str(global.coins)

func _on_box():
	shop(ITEM_BOX)
	
func _on_trap():
	shop(ITEM_TRAP)

func _on_turret():
	shop(ITEM_TURRET)

func _on_bomb():
	shop(ITEM_BOMB)

func shop(item):
	var details = ITEM_DETAILS[item]
	if global.coins >= details.price:
		$PickPlayer.play()
		emit_signal('shop', item)
		global.coins -= details.price
		update_text()

func _on_back():
	emit_signal("shop_back")

func _ready():
	$Box.connect("button_down", self, "_on_box")
	$Trap.connect("button_down", self, "_on_trap")
	$Turret.connect("button_down", self, "_on_turret")
	$Back.connect("button_down", self, "_on_back")
	$Bomb.connect("button_down", self, "_on_bomb")
	
	$BoxPrice.text = 'Price: ' + str(get_price(ITEM_BOX))
	$TrapPrice.text = 'Price: ' + str(get_price(ITEM_TRAP))
	$TurretPrice.text = 'Price: ' + str(get_price(ITEM_TURRET))
	$TurretPrice.text = 'Price: ' + str(get_price(ITEM_TURRET))
	$BombPrice.text = 'Price: ' + str(get_price(ITEM_BOMB))
	
	update_text()
