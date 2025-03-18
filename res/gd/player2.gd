extends "res://res/gd/player.gd"
func _physics_process(delta: float) -> void:
	direction=0
	if action:
		direction =action["left"]-action["right"]
	velocity.x=direction*speed
	velocity.y=0
	move_and_collide(velocity*delta)
