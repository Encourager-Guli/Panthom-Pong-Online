extends Control
@onready var main_menu: VBoxContainer = $main_menu
@onready var start_game: VBoxContainer = $start_game
@onready var ip: LineEdit = $start_game/IP
@onready var port: LineEdit = $start_game/port


func _on_single_pressed() -> void:
	main_menu.visible=false
	start_game.visible=true
	
	


func _on_start_pressed() -> void:
	if ip.text:
		GlobalConfig.server_ip=ip.text
	if port.text:
		GlobalConfig.server_port=port.text.to_int()
	
	get_tree().change_scene_to_file("res://res/tscn/game.tscn")
