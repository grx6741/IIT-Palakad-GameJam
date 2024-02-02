extends Node

var ClickAudio : AudioStreamPlayer2D

func _ready():
	ClickAudio = $AudioManager/ClickAudio

func _on_home_btn_pressed():
	ClickAudio.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	pass # Replace with function body.
