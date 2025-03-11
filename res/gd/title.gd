extends Control


func _on_single_pressed() -> void:
	get_tree().change_scene_to_file("res://res/tscn/game.tscn")
