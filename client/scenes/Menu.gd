extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Tutorial.connect("pressed", self, "_button_pressed", ["Tutorial"])
	$Game.connect("pressed", self, "_button_pressed", ["Game"])
	$Shop.connect("pressed", self, "_button_pressed", ["ShopMenu"])
	$Reward.connect("pressed", self, "_button_pressed", ["RewardMenu"])
	$Ranking.connect("pressed", self, "_button_pressed", ["RankingMenu"])
	
	_server_reward_update()
	_server_reward_handle()
	
	if not global.player_data.tutorial:
		$TutorialLabel.show()
		$TutorialLabel/AnimationPlayer.play("anim")
	else:
		$TutorialLabel.hide()
	
	$GoldLabel.text = "Current gold: " + str(global.player_data["gold"])

func _button_pressed(scene):
	if (not global.scene_manager._enabled):
		return
	global.scene_manager.change_scene(scene)

func _server_reward_update():
	# something something
	pass

func _server_reward_handle():
	# update rewards on global
	if global.rewards.size() > 0:
		$Reward/Notice.show()