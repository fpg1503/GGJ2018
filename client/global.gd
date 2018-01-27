extends Node

const TILE_SIZE = Vector2(80, 60)
const MAP_SIZE = Vector2(14,9)

const ACTORS = {
"Box": preload("res://scenes/actors/Box.tscn"),
"Player": preload("res://scenes/actors/Player.tscn")
}

const STAGES = {
"stage1": preload("res://scenes/tilemap/Stage1.tscn"),
}

func _ready():
	pass