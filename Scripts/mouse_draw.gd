extends Node2D

var _lines : Array = []

func _input(event: InputEvent) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not _lines.is_empty() and _lines[-1] != null:
			#print(_lines)
			_lines.append(null)
		return

	if _lines.is_empty():
		_lines.append(event.position)
	else:
		if _lines[-1] != event.position:
			_lines.append(event.position)
	queue_redraw()

func _draw() -> void:
	var i = 1
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
