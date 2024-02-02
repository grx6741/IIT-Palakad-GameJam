extends Node2D

func playSound():
	$AudioManager/PageChange.play()

func _on_play_pressed():
	playSound()
	await get_tree().create_timer(.7).timeout
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_tutorial_pressed():
	playSound()
	await get_tree().create_timer(.7).timeout
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")
