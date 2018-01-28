extends Node

const TILE_SIZE = Vector2(80, 60)
const MAP_SIZE = Vector2(14,8)

onready var coins = 10

const ACTORS = {
"Box": preload("res://scenes/actors/Box.tscn"),
"Player": preload("res://scenes/actors/Player.tscn"),
"Turret": preload("res://scenes/actors/Turret.tscn"),
"Trap": preload("res://scenes/actors/Trap.tscn"),
"Stone": preload("res://scenes/actors/Stone.tscn"),
}

const STAGES = {
"stage1": preload("res://scenes/tilemap/Stage1.tscn"),
}

const FACES = [
preload("res://assets/faces/layersdude-3.png"),
preload("res://assets/faces/layersdude-4.png"),
preload("res://assets/faces/layersdude-5.png"),
preload("res://assets/faces/layersdude-6.png"),
preload("res://assets/faces/layersdude-7.png")]

func _ready():
	randomize()