extends TextureRect

onready var tween = $Tween

signal shop
signal shop_back

enum Items { ITEM_BOX, ITEM_TRAP, ITEM_TURRET }
const ITEM_DETAILS = {
	ITEM_BOX: {
		'price': 5,
		'name': 'Box'
	},
	ITEM_TRAP: {
		'price': 3,
		'name': 'Trap'
	},
	ITEM_TURRET: {
		'price': 10,
		'name': 'Turret'
	}
}

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
		
func shop(item):
	var details = ITEM_DETAILS[item]
	if global.coins >= details.price:
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
	update_text()
