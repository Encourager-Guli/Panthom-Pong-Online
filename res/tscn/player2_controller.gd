extends "res://addons/godot_rl_agents/controller/ai_controller_2d.gd"
func set_action(action) -> void:
	player2.action=action	
	ball.action2=action
func reset():
	#重置整个环境交给p1进行，这里只需要重置相应的训练数据
	#game.reset()
	n_steps = 0
	needs_reset = false
	done=false
func process_obs(obs):
	obs[0]=1-obs[0]
	obs[1]=1-obs[1]
	obs[2]*=-1
	obs[3]=1-obs[3]
	obs[4]=1-obs[4]
	obs[5]*=-1
	obs[6]=1-obs[6]
	obs[7]=1-obs[7]
	obs[8]*=-1
	obs[9]*=-1
	return obs
func _on_ball_collide(collider: Variant) -> void:
	if collider=="player1":
		reward=-0.1
	elif collider=="player2":
		reward=0.1
	elif collider=="p1deadline":
		reward=1
		done=true
		game.pause()
	elif collider=="p2deadline":
		reward=-1
		done=true
		game.pause()
func _physics_process(delta: float) -> void:
	print()
