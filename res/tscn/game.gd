extends Node2D
@onready var player_1: CharacterBody2D = $player1
@onready var player_2: CharacterBody2D = $player2
@onready var ball: CharacterBody2D = $ball
@onready var game: Node2D = $"."
@onready var p_2_score: Label = $p2_score
@onready var p_1_score: Label = $p1_score

var p1score=0
var p2score=0


func reset() -> void:
	player_1.reset()
	player_2.reset()
	ball.reset()
	
	resume()
func pause() ->void:
	player_1.process_mode=Node.PROCESS_MODE_DISABLED
	player_2.process_mode=Node.PROCESS_MODE_DISABLED
	ball.process_mode=Node.PROCESS_MODE_DISABLED
func resume() -> void:
	player_1.process_mode=Node.PROCESS_MODE_INHERIT
	player_2.process_mode=Node.PROCESS_MODE_INHERIT
	ball.process_mode=Node.PROCESS_MODE_INHERIT


func _on_ball_collide(collider: Variant) -> void:
	if collider=="p1deadline":
		p2score+=1
		p_2_score.text=str(p2score)
	elif collider=="p2deadline":
		p1score+=1
		p_1_score.text=str(p1score)
