extends "res://Scripts/create_colliders.gd"

var _lines: Array = []
var _rigidBodies: Array = []

var _optionNode: OptionButton
var _clearButtonNode: Button

# Helper Functions

func get_null(array: Array, start: int = 0) -> int:
	for i in range(start, len(array)):
		if array[i] == null:
			return i
	return -1

# Button Handles

func _on_button_pressed() -> void:
	for rb in _rigidBodies:
		remove_child(rb)
		rb.free()
	_rigidBodies.clear()
	_lines.clear()

func _ready() -> void:
	_optionNode = get_node("UI/StrokeOptions")
	_clearButtonNode = get_node("UI/Button")

	_optionNode.focus_mode = BaseButton.FOCUS_NONE
	_clearButtonNode.focus_mode = BaseButton.FOCUS_NONE

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return
	if event is InputEventKey and event.pressed and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event.keycode == KEY_SPACE:
			constructRigidBodies()
			_lines.clear()
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not _lines.is_empty() and _lines[-1] != null:
			_lines.append(null)
		return
	if not event is InputEventKey:
		if _lines.is_empty():
			_lines.append(event.position)
		else:
			if _lines[-1] != event.position:
				_lines.append(event.position)
		queue_redraw()

func constructRigidBodies() -> void:
	var i: int = 0
	var j: int = get_null(_lines, i)

	while j > 0:
		var line2d: Line2D = Line2D.new()
		while i < j:
			line2d.add_point(_lines[i])
			line2d.width = 3
			i += 1
		if line2d.get_point_count() < 1:
			continue
		var rigidBody = RigidBody2D.new()
		handleColliderCreation(rigidBody, line2d.points)
		print(1, " ", len(line2d.points))
		rigidBody.add_child(line2d)
		rigidBody.mass = len(line2d.points)
		# rigidBody.kine
		add_child(rigidBody)
		_rigidBodies.append(rigidBody)
		i = j + 1
		j = get_null(_lines, i)

func _draw() -> void:
	if len(_lines) > 1:
		var i: int = 1
		while i < len(_lines):
			var prev = _lines[i-1]
			var curr = _lines[i]
			if curr == null or prev == null:
				i += 2
				continue
			draw_line(prev, curr, Color.BLACK, 10, true)
			draw_circle(prev, 5, Color.BLACK)
			draw_circle(curr, 5, Color.BLACK)
			i += 1