extends Panel

const FILE_BEGIN = "res://Levels/level_"
var click_sound:AudioStreamPlayer2D
var hasPlayed = false


func _ready():
	click_sound = $Audio/ClickSound

# func _on_child_entered_tree(node):
# 	$WinSound.play()

func _on_click_sound_finished():
	loadLevel()

func loadLevel():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)
	visible = false

func _on_next_pressed():
		click_sound.play()
		# if click_sound.finished:
		# 	loadLevel()

func _process(delta):
	if(visible == true and not hasPlayed):
		$Audio/WinSound.play()
		hasPlayed = true


