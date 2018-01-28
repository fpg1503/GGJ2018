extends "Actor.gd"

onready var raycast = $Area2D/RayCast2D

func _process(delta):
	if is_destroyed:
		return
	if (raycast.is_colliding()):
		var actor = raycast.get_collider()
		if actor:
			actor = actor.get_parent()
		if (actor and actor.type == "Player"):
			actor.destroy()
			if (not $AnimationPlayer.is_playing()):
				$AnimationPlayer.play("shoot")

func _on_destroyed():
	$AnimationPlayer.play("destroyed")

func _ready():
	type = "Turret"
	raycast.cast_to = Vector2(-position.x, 0)
	set_process(true)
	connect("destroyed", self, "_on_destroyed")