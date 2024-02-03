extends Node2D

@onready var _audio_player: AudioStreamPlayer2D = $DrawingAudioManager
@onready var heart: Node2D = $".."


func _on_player_interface__signal_draw_audio():
	_audio_player.pitch_scale = randf()/4.0 + 1.0
	if not _audio_player.playing:
		_audio_player.play()

func _on_player_interface__signal_not_draw_audio():
	_audio_player.stop()

func _process(_delta):
	position = heart.global_position
