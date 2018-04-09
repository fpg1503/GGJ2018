extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$BackButton.connect("pressed", self, "_on_back_pressed")
	$Success/RewardButton.connect("pressed", self, "_on_reward_pressed")
	
	if global.rewards.size() > 0:
		$Success.show()
		$Fail.hide()
		
		$Success/SuccessLabel.text = global.rewards[0][0] + "\n was got into your trap!"
	else:
		$Success.hide()
		$Fail.show()

func _on_reward_pressed():
	var gold = randi()%5 + 5
	$Success/Label.text = str(gold) + " gold reward!"
	$Success/AnimationPlayer.play("reward")
	global.player_data["gold"] += gold
	
	_send_rewarded_to_server()
	global.rewards.pop_front()
	global.save_player_data()

func _send_rewarded_to_server():
	pass

func _on_back_pressed():
	global.scene_manager.change_scene("MainMenu")
