extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player_1: CharacterBody2D = $"."

var speed=220
var action=null
var origin_pos
var direction
func _ready() -> void:
	origin_pos=global_position
func _physics_process(delta: float) -> void:
	direction=0
	if action:
		direction =action["right"]-action["left"]
	velocity.x=direction*speed
	velocity.y=0
	move_and_collide(velocity*delta)
	
func get_player1_obs() ->Array:
	return[global_position.x/512,global_position.y/512,direction]
func reset():
	global_position=origin_pos
func get_collide_length():
	return collision_shape_2d.shape.b.x*player_1.transform.get_scale().x
