extends CharacterBody2D
var player1 :CharacterBody2D
var player2 :CharacterBody2D
var collider_length
var speed:float=300
var direction=0
var speedup=[1.0,1.5,2.0]
var runningspeed
var reward=0
var done :bool=false
var action=null
signal collide(collider)
var origin_pos
var origin_speed
var speedplus=1.0
@onready var speedrank: Label = $"../speedrank"


func _ready() -> void:
	
	direction=randf()*PI/2+PI/4
	velocity=Vector2(1,0)
	velocity=velocity.rotated(direction)
	var player1_path = "../player1"
	var player2_path = "../player2"
	player1 = get_node(player1_path)
	player2 = get_node(player2_path)
	origin_pos=global_position
	origin_speed=speed
	runningspeed=velocity*speed
	collider_length=player1.get_collide_length()
func _physics_process(delta: float) -> void:
	var rank=0
	#if(Input.is_action_pressed("speedup1")):
		#
		#rank+=1
	if action:
		rank+=action["speedup"]
	if(Input.is_action_pressed("speedup1")):
		rank+=1
	set_speedrank_label(rank)
	runningspeed=velocity*speed*speedup[rank]
	speedplus=speed*speedup[rank]/origin_speed
	reward=0
	var message=move_and_collide(runningspeed*delta)
	
	if message:
		#print(message.get_collider())
		#var hitspace:float
		var normal:Vector2
		var collider_name=message.get_collider().name
		emit_signal("collide",collider_name)
		if collider_name=="player1" or 	collider_name=="player2":
			var collide_pos=message.get_position().x
			var collider=message.get_collider()
			speed*=1.05
			var dis=collide_pos-collider.global_position.x
			var softed_dis=dis/collider_length
			var n=message.get_normal()
			var max_angle=PI/3
			if collider_name=="player1":
				velocity=n.rotated(max_angle*softed_dis)
			elif collider_name=="player2":
				velocity=n.rotated(-1*max_angle*softed_dis)
		else:
			normal=message.get_normal()
			velocity=velocity.bounce(normal).normalized()
	
func get_ball_obs() -> Array:
	if global_position==null:
		print("not ready")
		await (ready)
	return [global_position.x/512,global_position.y/512,velocity.x,velocity.y,speedplus]

func get_reward() -> float:
	return reward

func reset():
	global_position=origin_pos
	speed=origin_speed
	direction=randf()*PI/2+PI/4
	velocity=Vector2(1,0)
	velocity=velocity.rotated(direction)
	speedplus=0
func set_speedrank_label(rank):
	print(rank)
	var color:Color
	var lable_scale=1
	match rank:
		0:
			color = Color("#00FFAA")  # 低速
		1:
			color = Color("#FFD700")  # 中速
			lable_scale=1.2
		2:
			color = Color("#FF3300")  # 高速
			lable_scale=1.5
	speedrank.text="speed rank:"+str(rank)
	speedrank.add_theme_color_override("font_color", color)
	speedrank.scale=Vector2(lable_scale,lable_scale)
