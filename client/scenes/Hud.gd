extends TextureRect

onready var tween = $Tween

signal play
signal stop
signal shop
signal reset

func enter():
	tween.interpolate_property(self, "rect_position", rect_position, Vector2(rect_position.x, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	enable_buttons()

func exit():
	tween.interpolate_property(self, "rect_position", rect_position, Vector2(rect_position.x, -rect_size.y), 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	pass

func enable_buttons():
	$Play.disabled = false
	$Play.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	$Stop.disabled = true
	$Stop.modulate = Color(1.0, 1.0, 1.0, 0.4)
	
	$Shop.disabled = false
	$Shop.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	$Reset.disabled = false
	$Reset.modulate = Color(1.0, 1.0, 1.0, 1.0)

func disable_buttons():
	$Play.disabled = true
	$Play.modulate = Color(1.0, 1.0, 1.0, 0.4)
	
	$Shop.disabled = true
	$Shop.modulate = Color(1.0, 1.0, 1.0, 0.4)
	
	$Reset.disabled = true
	$Reset.modulate = Color(1.0, 1.0, 1.0, 0.4)
	
	$Stop.disabled = false
	$Stop.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_play():
	emit_signal("play")
	disable_buttons()

func _on_stop():
	emit_signal("stop")
	enable_buttons()

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
