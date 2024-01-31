extends Node

var game_paused: bool

func _ready():
	$Pause_Menu.visible = false

func _input(event: InputEvent):
	if Input.is_action_pressed("ui_cancel"):
		game_paused = get_tree().paused
		game_paused = not game_paused
		$Pause_Menu.visible = not $Pause_Menu.visible
