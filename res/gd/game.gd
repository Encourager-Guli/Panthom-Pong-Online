extends Node2D
@onready var player_1: CharacterBody2D = $player1
@onready var player_2: CharacterBody2D = $player2
@onready var ball: CharacterBody2D = $ball
@onready var game: Node2D = $"."



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
