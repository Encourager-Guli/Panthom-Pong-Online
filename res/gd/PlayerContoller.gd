extends AIcontroller
class_name PlayerController
var player1path="/root/game/player1"
var player2path="/root/game/player2"
var ballpath="/root/game/ball"

var player1
var player2
var ball
var mheuristic
var needs_reset=false
func _ready() -> void:
	
	await get_tree().root.ready
	player1=get_node(player1path)
	player2=get_node(player2path)
	ball=get_node(ballpath)
	await player1.ready
	await player2.ready
	await  ball.ready
	
	
func get_obs() -> Dictionary:
	var obs=[]
	obs.append_array(player1.get_player1_obs())
	obs.append_array(player2.get_player2_obs())
	obs.append_array(ball.get_ball_obs())
	
	return {"obs":obs}
func get_reward() -> float:
	return ball.get_reward()
func _physics_process(delta: float) -> void:
	pass
	print(get_obs())
	#if(needs_reset):
		#get_tree().reload_current_scene()
func get_action_space() -> Dictionary:
	return{
		
		"left" : {
			"size": 2,
			"action_type": "discrete"
		},
		"right" : {
			"size": 2,
			"action_type": "discrete"
		},
		"speedup" : {
			"size": 2,
			"action_type": "discrete"
		}
		
	}
func set_action(action) -> void:
	player1.action=action	
	ball.action=action
func get_done()->bool:
	return ball.get_done()
func set_heuristic(heuristic):
	mheuristic=heuristic
func set_done_false():
	ball.done=false
func get_obs_space():
	return {
	   "obs":{
		
			"space": "box",
			"size": [10]
		}
	}
func zero_reward():
	ball.reward=0
