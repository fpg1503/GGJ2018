extends Node2D

func _on_player_move(vec2):
	var new_pos = $Player.target_pos + Vector2(vec2.x*global.TILE_SIZE.x, vec2.y*global.TILE_SIZE.y)
	$Player.move_to(new_pos)

func _ready():
	$Player.connect("move", self, "_on_player_move")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
