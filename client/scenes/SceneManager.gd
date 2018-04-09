extends Control

onready var _enabled = false

func show_connection_error():
	$ConnectionError/AnimationPlayer.play("appear")

func change_scene(new_scene):
	var scene = $CurrentScene.get_child(0)
	scene.queue_free()
	var instanced = global.SCENES[new_scene].instance()
	$CurrentScene.add_child(instanced)

func _check_nickname(anim):
	if (global.player_data["nickname"] == ""):
		_change_nickname()
	else:
		_enabled = true

func _change_nickname():
	$PopupPanel.show()
	$AnimationPlayer.play("blackscreen_alpha")

func _close_nickname():
	$AnimationPlayer.play_backwards("blackscreen_alpha")
	$PopupPanel.hide()
	_enabled = true

func _ready():
	global.scene_manager = self
	$LockedScreen/AnimationPlayer.connect("animation_finished", self, "_check_nickname")
	$PopupPanel.connect("closed", self, "_close_nickname")

func _flick():
	pass