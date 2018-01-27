extends Control

enum GAME_STATE {SETTING_UP, PLAYING, CREATING, TESTING}

onready var current_stage = 0
onready var state = GAME_STATE.SETTING_UP setget set_state
onready var won = false

func set_state(new_state):
	if (new_state == CREATING):
		$Hud.enter()
	state = new_state

func _on_won():
	set_state(GAME_STATE.CREATING)

func _on_lost():
	set_state(GAME_STATE.CREATING)

func _ready():
	$Grid.connect("won", self, "_on_won")
	$Grid.connect("lost", self, "_on_lost")
	
	$Grid.set_grid("stage1")
	state = GAME_STATE.PLAYING
	$Grid.start_game()