extends Control

enum GAME_STATE {SETTING_UP, PLAYING, CREATING, TESTING}

onready var current_stage = 0
onready var state = GAME_STATE.SETTING_UP setget set_state
onready var won = false
onready var map_id = null
onready var follow_type = null

onready var ended = false

onready var original_map = []
onready var current_map = []

onready var level_loaded = false
onready var time_is_up = false
onready var timer = Timer.new()

onready var level_sent = false
onready var send_time_is_up = false
onready var send_timer = Timer.new()

const UserIdentifier = preload("res://UserIdentifier.gd")

func load_original_grid():
	current_map = original_map.duplicate()
	load_grid(current_map)

func load_grid(grid):
	$Grid.reset_grid()
	for item in grid:
		$Grid.insert(item.type, item.x, item.y)

func set_state(new_state):
	if (new_state == CREATING):
		$Hud.enter()
	
	if (state == PLAYING and new_state == CREATING):
		$AudioStreamPlayer.stream = global.MUSIC["boot_camp"]
		$AudioStreamPlayer.play(0.0)
		load_original_grid()
	elif (state == TESTING and new_state == CREATING):
		load_grid(current_map)
		
	if new_state == PLAYING:
		print('hiding')
		$Grid.get_tree().call_group('traps', 'hide')
	else:
		print('showing')
		$Grid.get_tree().call_group('traps', 'show')
	
	state = new_state

func level_fetched(error, level, grid_info, map_id):
	print('Successfully fetched level ' + str(level))
	self.map_id = map_id
	original_map = grid_info
	hide_loading()
	
func show_loaded_map():
	$Loading.hide()
	load_original_grid()
	$Grid.start_game()
	set_state(GAME_STATE.PLAYING)
	
	$AudioStreamPlayer.stream = global.MUSIC["spy_time"]
	$AudioStreamPlayer.play(0.0)

func send_grid_to_server():
#	var map = []
#	for child in $Grid.get_children():
#		var position = child.get_position()
#		var x = position.x / global.TILE_SIZE.x
#		var y = position.y / global.TILE_SIZE.y
#		if child.has_method('get_type'):
#			map.append({'x': x, 'y': y, 'type': child.get_type()})
	var user = UserIdentifier.get_unique_id()
	Server.save_level(1, current_map, user, map_id)

func _on_won():
	$WonPlayer.play()
	if(state == GAME_STATE.TESTING):
		$Hud.exit()
		$Grid.hide()
		send_grid_to_server()
		show_seding()
	else:
		set_state(GAME_STATE.CREATING)

func _on_lost():
	set_state(GAME_STATE.CREATING)
	$LostPlayer.play()	

func _on_hud_play():
	set_state(GAME_STATE.TESTING)
	load_grid(current_map)
	$Grid.start_game()

func _on_hud_stop():
	if($Grid.player and $Grid.player.falling):
		return
	$Grid.kill_player()
	$Hud.enable_buttons()

func _on_hud_shop():
	$Shop.enter()
	$Hud.exit()

func _on_hud_reset():
	load_original_grid()
	global.coins = 10
	$Shop.update_text()

func _on_shop(item):
	$Follow.texture = $Shop.get_asset(item)
	$Follow.active = true
	follow_type = item

func _on_shop_back():
	$Shop.exit()
	$Hud.enter()

func _delete_on_pos(pos):
	for item in current_map:
		print(item)
		print(pos)
		if item.x == pos.x and item.y == pos.y:
			current_map.erase(item)
			print(current_map.size())

func _on_place_item(pos):
	if (follow_type == $Shop.ITEM_BOMB):
		for tx in range(3):
			for ty in range(3):
				var tile = Vector2(pos.x-1+tx, pos.y-1+ty)
				if $Grid.gridmap.has(tile) and $Grid.gridmap[tile].type != "Player":
					$Grid.gridmap[tile].destroy()
					_delete_on_pos(tile)
				if $Grid.traps.has(tile) and $Grid.traps[tile].type != "Trapdoor":
					$Grid.traps[tile].destroy()
					_delete_on_pos(tile)
	
	elif $Grid.insert($Shop.get_name(follow_type), pos.x, pos.y):
		$PopPlayer.play()
		current_map.append({'type': $Shop.get_name(follow_type), 'x': pos.x, 'y': pos.y})
	else:
		global.coins += $Shop.get_price(follow_type)
		$Shop.update_text()

func _on_level_saved(err):
	hide_sending()

func _ready():
	set_process_input(true)
	Server.connect("level_saved", self, "_on_level_saved")
	
	$Grid.connect("won", self, "_on_won")
	$Grid.connect("lost", self, "_on_lost")
	
	$Hud.connect("play", self, "_on_hud_play")
	$Hud.connect("stop", self, "_on_hud_stop")
	$Hud.connect("shop", self, "_on_hud_shop")
	$Hud.connect("reset", self, "_on_hud_reset")
	
	$Shop.connect("shop", self, "_on_shop")
	$Shop.connect("shop_back", self, "_on_shop_back")
	
	$Follow.connect("place_item", self, "_on_place_item")
	
	var user = UserIdentifier.get_unique_id()
#	Server.fetch_level(1, user)
	show_loading()
	
	$Grid.set_grid('stage1')
	$Grid.start_game()

#	Server.connect('level_fetched', self, 'level_fetched')


func show_loading():
	add_child(timer)
	timer.wait_time = 3
	timer.one_shot = true
	timer.connect('timeout', self, '_on_timeout')
	timer.start()
	$Loading.show()

func _on_timeout():
	if level_loaded:
		print('Timeout and level loaded!')
		show_loaded_map()
	else:
		print('Timeout, level is not yet loaded')
		time_is_up = true

func hide_loading():
	level_loaded = true
	print('Level finished loading')
	if time_is_up:
		print('Level loaded after timeout')
		show_loaded_map()
		
func show_seding():
	add_child(send_timer)
	send_timer.wait_time = 3
	send_timer.one_shot = true
	send_timer.connect('timeout', self, '_on_timeout_send')
	send_timer.start()
	$Sending.show()

func _on_timeout_send():
	if level_sent:
		print('Timeout and level saved!')
		$Sending/Label.text = "Click to play again!"
		ended = true
	else:
		print('Timeout, level is not yet saved')
		send_time_is_up = true

func hide_sending():
	level_sent = true
	print('Level finished sending')
	if send_time_is_up:
		print('Level sent after timeout')
		# TODO

func _input(event):
	if ended and event.is_pressed():
		get_tree().change_scene("res://scenes/Game.tscn")
	if event.as_text() == 'S' and event.is_pressed() and not event.is_echo():
		print('Sending to server!')
		# TODO: Send grid after being tested by user
		send_grid_to_server()
