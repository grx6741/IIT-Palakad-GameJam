extends "res://Scripts/create_colliders.gd"

enum StrokeMode {
	NORMAL_STROKE,
	ERASER_STROKE,
	JOINT_STROKE,
}

var _lines: Array = []
var _rigidBodies: Array = []

var _optionNode: OptionButton
var _clearButtonNode: Button
var _unFreezeButtonNode : Button

var _mouse_axis_point_map : Dictionary = {}
var _cell_size: int = 20

# Helper Functions

func get_null(array: Array, start: int = 0) -> int:
	for i in range(start, len(array)):
		if array[i] == null:
			return i
	return -1

func _get_line2D(rb: RigidBody2D) -> Line2D:
	for child in rb.get_children():
		if child is Line2D:
			return child
	return null

func get_2_closest_rb(pos: Vector2, rbs: Array) -> Array:
	var _closest = -1
	var _closest_distance = INF

	var _second_closest = -1
	var _second_closest_distance = INF
	print(_second_closest_distance)
	for i in range(len(rbs)):
		var children = rbs[i].get_children()
		for j in range(len(children)):
			if children[j] is CollisionShape2D:
				var p: Vector2 = children[j].get_global_position()
				var dist: float = p.distance_squared_to(pos)
				if dist < _second_closest_distance:
					if dist < _closest_distance:
						_second_closest = _closest
						_second_closest_distance = _closest_distance

						_closest = i
						_closest_distance = dist
					elif i != _closest:
						_second_closest = i
						_second_closest_distance = dist
	return [_closest, _second_closest]

# Button Handles

func _on_button_pressed() -> void:
	for rb in _rigidBodies:
		remove_child(rb)
		rb.free()
	_rigidBodies.clear()
	_lines.clear()

func _on_button_2_pressed():
	for rb in _rigidBodies:
		rb.freeze = false

func _ready() -> void:
	_optionNode = get_node("UI/StrokeOptions")
	_clearButtonNode = get_node("UI/Button")
	_unFreezeButtonNode = get_node("UI/Button2")

	_optionNode.focus_mode = BaseButton.FOCUS_NONE
	_clearButtonNode.focus_mode = BaseButton.FOCUS_NONE
	_unFreezeButtonNode.focus_mode = BaseButton.FOCUS_NONE

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
		# queue_redraw()

func constructRigidBodies() -> void:
	var i: int = 0
	var j: int = get_null(_lines, i)

	while j > 0:
		var line2d: Line2D = Line2D.new()
		while i < j:
			line2d.add_point(_lines[i] - line2d.global_position)
			line2d.width = 3
			i += 1
		if line2d.get_point_count() < 1:
			continue

		var rigidBody = RigidBody2D.new()
		handleColliderCreation(rigidBody, line2d.points)
		rigidBody.add_child(line2d)
		rigidBody.mass = len(line2d.points)
		rigidBody.freeze = true
		rigidBody.collision_mask = 2

		# rigidBody.kine
		add_child(rigidBody)
		_rigidBodies.append(rigidBody)
		i = j + 1
		j = get_null(_lines, i)

func in_between_x(a: Vector2, b:Vector2, c: Vector2) -> bool:
	return ( a.x <= c.x and c.x <= b.x ) or ( b.x <= c.x and c.x <= a.x )

func in_between_y(a: Vector2, b:Vector2, c: Vector2) -> bool:
	return ( a.y <= c.y and c.y <= b.y ) or ( b.y <= c.y and c.y <= a.y )

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
	if _optionNode.get_selected_id() == StrokeMode.JOINT_STROKE:
		_mouse_axis_point_map.clear()
		var mouse_pos: Vector2i = get_viewport().get_mouse_position()
		# print(mouse_pos)
		if _rigidBodies.is_empty():
			return
		for j in len(_rigidBodies):
			var rb: RigidBody2D = _rigidBodies[j]
			var children: Array = rb.get_children()
			for i in range(1, children.size()):
				if children[i] is CollisionShape2D:
					var prev_pos = children[i-1].global_position
					var curr_pos = children[i].global_position

					if (in_between_x(prev_pos, curr_pos, mouse_pos)):
						var _pos = Vector2(mouse_pos.x, 0.5 * (prev_pos.y + curr_pos.y))
						draw_circle(_pos, 10, Color.RED)
					if (in_between_y(prev_pos, curr_pos, mouse_pos)):
						var _pos = Vector2(0.5 * (prev_pos.x + curr_pos.x), mouse_pos.y)
						draw_circle(_pos, 10, Color.RED)

		var rbs = get_2_closest_rb(mouse_pos, _rigidBodies)
		var closest = rbs[0]
		var second_closest = rbs[1]
		for i in range(len(_rigidBodies)):
			var line: Line2D = _get_line2D(_rigidBodies[i])
			if i == closest or i == second_closest:
				line.width = 10
			else:
				line.width = 3


func _process(delta: float) -> void:
	queue_redraw()