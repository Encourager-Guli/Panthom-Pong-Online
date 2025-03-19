extends CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var speed=220
var ball:Node
var origin_pos
var direction=Vector2(0,0)
var action=null
func _ready() -> void:
	var ball_path = "../ball"
	ball = get_node(ball_path)
	origin_pos=global_position
func _physics_process(delta: float) -> void:
	direction=Vector2(0,0)
	#对象的运动是反着的
	if action:
		direction=Vector2(action["left"]-action["right"],0)
	
	#var direction =Input.get_axis("left","right")
	velocity.x=direction.x*speed
	velocity.y=0
	move_and_collide(velocity*delta)
	
func get_player2_obs() -> Array:
	return [global_position.x/512,global_position.y/512,direction.x]
func reset():
	global_position=origin_pos
