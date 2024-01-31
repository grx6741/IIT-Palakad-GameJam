extends Node2D

var _audio_player: AudioStreamPlayer2D
var heart: Node2D


func _on_player_interface__signal_draw_audio():
	_audio_player.pitch_scale = randf()/4.0 + 1.0
	if not _audio_player.playing:
		_audio_player.play()
		print("Playing")


func _on_player_interface__signal_not_draw_audio():
	_audio_player.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	_audio_player = $DrawingAudioManager
	heart = get_node("../../Heart")
	print(heart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = heart.global_position



