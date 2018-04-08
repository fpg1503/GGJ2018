extends Panel

signal closed

func _ok_pressed():
#	print(global.player_data)
	global.player_data["nickname"] = $LineEdit.text
	global.save_player_data()
	emit_signal("closed")

func _ready():
	$Button.connect("pressed", self, "_ok_pressed")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
