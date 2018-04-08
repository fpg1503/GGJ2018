extends Node

const TILE_SIZE = Vector2(80, 60)
const MAP_SIZE = Vector2(14,8)

const SCENES = {
"MainMenu": preload("res://scenes/Menu.tscn"),
"ShopMenu": preload("res://scenes/ShopMenu.tscn"),
"Game": preload("res://scenes/Game.tscn"),
"Tutorial": preload("res://scenes/Tutorial.tscn"),
}

const ACTORS = {
"Box": preload("res://scenes/actors/Box.tscn"),
"Player": preload("res://scenes/actors/Player.tscn"),
"Turret": preload("res://scenes/actors/Turret.tscn"),
"Trap": preload("res://scenes/actors/Trap.tscn"),
"Stone": preload("res://scenes/actors/Stone.tscn"),
"Trapdoor": preload("res://scenes/actors/Trapdoor.tscn"),
}

const MUSIC = {
"boot_camp": preload("res://assets/boot_camp.ogg"),
"spy_time": preload("res://assets/spy_time.ogg"),
}

const STAGES = {
"stage1": preload("res://scenes/tilemap/Stage1.tscn"),
"stage2": preload("res://scenes/tilemap/Stage2.tscn"),
"stage3": preload("res://scenes/tilemap/Stage3.tscn"),
"stage4": preload("res://scenes/tilemap/Stage4.tscn"),
}

const FACES = [
preload("res://assets/faces/layersdude-3.png"),
preload("res://assets/faces/layersdude-4.png"),
preload("res://assets/faces/layersdude-5.png"),
preload("res://assets/faces/layersdude-6.png"),
preload("res://assets/faces/layersdude-7.png")]

onready var scene_manager = null
onready var coins = 10

onready var player_data = {
"gold": 0,
"tutorial": false,
"nickname": "",
}

onready var savegame = File.new()
onready var save_path = "user://savegame.bin"

func check_savegame():
#	savegame.open(save_path, File.WRITE)
#	savegame.store_var(player_data)
#	savegame.close()
	
	if not savegame.file_exists(save_path):
		savegame.open(save_path, File.WRITE)
		savegame.store_var(player_data)
		savegame.close()
	else:
		load_player_data()

func save_player_data():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(player_data)
	savegame.close()

func load_player_data():
	savegame.open(save_path, File.READ)
	player_data = savegame.get_var()
	print(player_data)
	savegame.close()

func _ready():
	randomize()
#	save_player_data()
	check_savegame()