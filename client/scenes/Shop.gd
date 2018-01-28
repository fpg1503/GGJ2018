extends TextureRect

onready var tween = $Tween

signal shop_box
signal shop_trap
signal shop_back

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
	if(global.coins >= 5):
		emit_signal("shop_box")
		global.coins -= 5
		update_text()

func _on_trap():
	if(global.coins >= 3):
		emit_signal("shop_trap")
		global.coins -= 3
		update_text()

func _on_back():
	emit_signal("shop_back")

func _ready():
	$Box.connect("button_down", self, "_on_box")
	$Trap.connect("button_down", self, "_on_trap")
	$Back.connect("button_down", self, "_on_back")
	update_text()
