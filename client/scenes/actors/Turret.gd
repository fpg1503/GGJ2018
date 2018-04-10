extends "Actor.gd"

onready var raycast = $Area2D/RayCast2D
onready var draw_limit_x = -1200
onready var light_tick = 0.0


func _process(delta):
	light_tick += delta*(2.0+randf()*2.0)
	
	if is_destroyed:
		return
	if (raycast.is_colliding()):
		var actor = raycast.get_collider()
		if actor:
			actor = actor.get_parent()
		
		
		var new_draw_limit_x = -1200
		if (actor):
			new_draw_limit_x = actor.position.x - position.x
		if (actor and actor.type == "Player"):
			new_draw_limit_x = actor.position.x - position.x - 80
			actor.destroy()
#			if (not $AnimationPlayer.is_playing()):
#				$AnimationPlayer.play("shoot")
#				$Player.play()
		draw_limit_x = new_draw_limit_x
	update()

func _draw():
	draw_rect(Rect2(Vector2(-40, -20), Vector2(draw_limit_x+80, 40)),Color(0.9,0.9,0.9,(0.1 + sin(light_tick)*0.05)),true)
#	draw_rect(Rect2(Vector2(-50, -15), Vector2(draw_limit_x+100, 30)),Color(0.9,0.9,0.9,0.4),true)

func _on_destroyed():
	$AnimationPlayer.play("destroyed")

func _ready():
	type = "Turret"
	raycast.cast_to = Vector2(-position.x, 0)
	set_process(true)
	connect("destroyed", self, "_on_destroyed")