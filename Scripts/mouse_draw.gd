extends Node2D

var _lines: Array = []

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			constructRigidBodies()
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not _lines.is_empty() and _lines[-1] != null:
			_lines.append(null)
		return

	if _lines.is_empty():
		_lines.append(event.position)
	else:
		if _lines[-1] != event.position:
			_lines.append(event.position)
	queue_redraw()

func get_null(array: Array, start: int = 0) -> int:
	for i in range(start, len(array)):
		if array[i] == null:
			return i
	return -1
	
func constructRigidBodies() -> void:
	var i: int = 0
	var j: int = get_null(_lines, i)
	var _rigidBodies: Array = []

	while i < len(_lines) and j > 0:
		var line2d = Line2D.new()
		while i < j:
			line2d.add_point(_lines[i])
			i += 1
		var rigidBody = RigidBody2D.new()
		rigidBody.add_child(line2d)
		# add_child(rigidBody)
		_rigidBodies.append(rigidBody)
		i = j + 1
		j = get_null(_lines, i)

func _draw() -> void:
	var i: int = 1
	while i < len(_lines):
		var prev = _lines[i-1]
		var curr = _lines[i]
		if curr == null or prev == null:
			i += 2
			continue
		draw_line(prev, curr, Color.BLACK, 20, true)
		draw_circle(prev, 10, Color.BLACK)
		draw_circle(curr, 10, Color.BLACK)
		i += 1
