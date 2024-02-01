extends Control

@export var game_manager : GameManager


func _ready():
	hide()
	game_manager.connect("toggle_game_pause", _on_game_manager_toggle_game_pause)

func _on_game_manager_toggle_game_pause(is_paused : bool):
	if is_paused:
		show()
	else:
		hide()


func _on_resume_btn_pressed():
	pass # Replace with function body.

func _on_back_to_menu_btn_pressed():
	pass # Replace with function body.

func _on_exit_btn_pressed():
	pass # Replace with function body.
