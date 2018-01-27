extends TextureRect

onready var tween = $Tween

signal play
signal stop
signal shop
signal reset

func enter():
	tween.interpolate_property(self, "rect_position", rect_position, Vector2(rect_position.x, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	pass

func exit():
	tween.interpolate_property(self, "rect_position", rect_position, Vector2(rect_position.x, -rect_size.y), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	pass

func _on_play():
	emit_signal("play")

func _on_stop():
	emit_signal("stop")

func _on_shop():
	emit_signal("shop")

func _on_reset():
	emit_signal("reset")

func _ready():
	$Play.connect("button_down", self, "_on_play")
	$Stop.connect("button_down", self, "_on_stop")
	$Shop.connect("button_down", self, "_on_shop")
	$Reset.connect("button_down", self, "_on_reset")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
