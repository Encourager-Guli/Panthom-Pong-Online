extends Node2D
class_name AIController2D
@onready var player1: CharacterBody2D = $".."
@onready var player2: CharacterBody2D = $"../../player2"
@onready var ball: CharacterBody2D = $"../../ball"
@onready var game: Node2D = $"../.."



enum ControlModes {
	INHERIT_FROM_SYNC, ## Inherit setting from sync node
	HUMAN, ## Test the environment manually
	TRAINING, ## Train a model
	ONNX_INFERENCE, ## Load a pretrained model using an .onnx file
	RECORD_EXPERT_DEMOS ## Record observations and actions for expert demonstrations
}
@export var control_mode: ControlModes = ControlModes.INHERIT_FROM_SYNC
## The path to a trained .onnx model file to use for inference (overrides the path set in sync node).
@export var onnx_model_path := ""
## Once the number of steps has passed, the flag 'needs_reset' will be set to 'true' for this instance.
@export var reset_after := 1000

@export_group("Record expert demos mode options")
## Path where the demos will be saved. The file can later be used for imitation learning.
@export var expert_demo_save_path: String
## The action that erases the last recorded episode from the currently recorded data.
@export var remove_last_episode_key: InputEvent
## Action will be repeated for n frames. Will introduce control lag if larger than 1.
## Can be used to ensure that action_repeat on inference and training matches
## the recorded demonstrations.
@export var action_repeat: int = 1

@export_group("Multi-policy mode options")
## Allows you to set certain agents to use different policies.
## Changing has no effect with default SB3 training. Works with Rllib example.
## Tutorial: https://github.com/edbeeching/godot_rl_agents/blob/main/docs/TRAINING_MULTIPLE_POLICIES.md
@export var policy_name: String = "shared_policy"

var onnx_model: ONNXModel

var heuristic := "human"
var done := false
var reward := 0.0
var n_steps := 0
var needs_reset := false

var _player: Node2D
signal agent_ready

func _ready():
	add_to_group("AGENT")
	emit_signal("agent_ready")
	if player1==null:
		print("error player 1 not ready")

func init(player: Node2D):
	_player = player


#region Methods that need implementing using the "extend script" option in Godot
func get_obs() -> Dictionary:
	var obs=[]
	obs.append_array(player1.get_player1_obs())
	obs.append_array(player2.get_player2_obs())
	obs.append_array(ball.get_ball_obs())
	
	return {"obs":obs}


func get_reward() -> float:
	return reward


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


#endregion


#region Methods that sometimes need implementing using the "extend script" option in Godot
# Only needed if you are recording expert demos with this AIController
func get_action() -> Array:
	assert(
		false,
		"the get_action method is not implemented in extended AIController but demo_recorder is used"
	)
	return []


# For providing additional info (e.g. `is_success` for SB3 training)
func get_info() -> Dictionary:
	return {}


#endregion


func _physics_process(delta):
	n_steps += 1
	if n_steps > reset_after:
		needs_reset = true

func get_obs_space():
	# may need overriding if the obs space is complex
	var obs = get_obs()
	return {
		"obs": {"size": [len(obs["obs"])], "space": "box"},
	}


func reset():
	game.reset()
	n_steps = 0
	needs_reset = false
	done=false

func reset_if_done():
	if done:
		reset()
		done=false


func set_heuristic(h):
	# sets the heuristic from "human" or "model" nothing to change here
	heuristic = h


func get_done():
	return done


func set_done_false():
	done = false


func zero_reward():
	reward = 0.0





func _on_ball_collide(collider: Variant) -> void:
	if collider=="player1":
		reward=0.1
	elif collider=="player2":
		reward=-0.1
	elif collider=="p1deadline":
		reward=-1
		done=true
		game.pause()
	elif collider=="p2deadline":
		reward=1
		done=true
		game.pause()
		
