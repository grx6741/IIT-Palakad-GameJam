extends "res://Scripts/create_colliders.gd"

enum StrokeMode {
	NORMAL_STROKE,
	ERASER_STROKE,
	JOINT_STROKE,
	ROTATION_STROKE_PI,
	ROTATION_STROKE_2PI,
	ROTATION_STROKE_3PI
}


var _lines: Array = []
var _rigidBodies: Array = []
var _erasable_body : int
var _optionNode: OptionButton
var _clearButtonNode: Button
var _unFreezeButtonNode : Button
var _RotatoryRbs_Type1 : Array
var _RotatoryRbs_Type2 : Array
var _RotatoryRbs_Type3 : Array

var _mouse_axis_point_map : Dictionary = {}
var _joinable_rigidbodies:Array = []
var joints = []
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
	# print(_second_closest_distance)
	for i in range(len(rbs)):
		var p: Vector2 = rbs[i][0]
		var dist: float = p.distance_squared_to(pos)
		if dist < _closest_distance:
			_closest = i
			_closest_distance = dist
	

	for i in range(len(rbs)):
		var p: Vector2 = rbs[i][0]
		var dist: float = p.distance_squared_to(pos)
		if dist < _second_closest_distance and rbs[i][1] != rbs[_closest][1]:
			# print(rbs[i][1]," : ",rbs[_closest][1])
			_second_closest = i
			_second_closest_distance = dist


	# print(_closest," : ",_second_closest)
	if(_closest == -1 or _second_closest == -1):
		return []
	return [rbs[_closest], rbs[_second_closest]]
	# return [_closest, _second_closest]
	# 	var children = rbs[i].get_children()
	# 	for j in range(len(children)):
	# 		if children[j] is CollisionShape2D:
	# 			var p: Vector2 = children[j].get_global_position()
	# 			var dist: float = p.distance_squared_to(pos)
	# 			if dist < _second_closest_distance:
	# 				if dist < _closest_distance:
	# 					_second_closest = _closest
	# 					_second_closest_distance = _closest_distance

	# 					_closest = i
	# 					_closest_distance = dist
	# 				elif i != _closest:
	# 					_second_closest = i
	# 					_second_closest_distance = dist
	# return [_closest, _second_closest]

# Button Handles

func _on_button_pressed() -> void:
	for rb in _rigidBodies:
		remove_child(rb)
		rb.free()
	_rigidBodies.clear()
	_RotatoryRbs_Type1.clear()
	_RotatoryRbs_Type2.clear()
	_RotatoryRbs_Type3.clear()
	_lines.clear()
	joints.clear()

func _on_button_2_pressed():
	for rb in _rigidBodies:
		rb.freeze = not rb.freeze

func _ready() -> void:
	_optionNode = get_node("UI/StrokeOptions")
	_clearButtonNode = get_node("UI/Button")
	_unFreezeButtonNode = get_node("UI/Button2")

	_optionNode.focus_mode = BaseButton.FOCUS_NONE
	_clearButtonNode.focus_mode = BaseButton.FOCUS_NONE
	_unFreezeButtonNode.focus_mode = BaseButton.FOCUS_NONE


func drawLines(event:InputEvent,rotatory:bool = false):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not event is InputEventKey:
			# push mouse positions to array
			if _lines.is_empty():
				_lines.append(get_global_mouse_position())
			else:
				if _lines[-1] != get_global_mouse_position():
					_lines.append(get_global_mouse_position())
	else:
		# push a null when not pressing mouse
		if not _lines.is_empty() and _lines[-1] != null:
			_lines.append(null)

		# Now i can't press space when holding down left mouse
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_SPACE:
				if(not rotatory):
					constructRigidBodies()
				if(rotatory):
					constructRigidBodiesRotatory(_optionNode.get_selected_id())
				_lines.clear()



func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return
	
	match _optionNode.get_selected_id():
		StrokeMode.JOINT_STROKE:
			if event is InputEventKey:
				if event.keycode == KEY_SPACE:
					if (len(_joinable_rigidbodies) >= 2):
						create_Joints(_joinable_rigidbodies[0], _joinable_rigidbodies[1], 10)
		StrokeMode.NORMAL_STROKE:
			drawLines(event)
		StrokeMode.ERASER_STROKE:
			if event is InputEventKey:
				if event.keycode == KEY_SPACE and _erasable_body != -1:
					remove_child(_rigidBodies[_erasable_body])
					_rigidBodies[_erasable_body].free()
					_rigidBodies.pop_at(_erasable_body)
					_erasable_body = -1
		StrokeMode.ROTATION_STROKE_PI :
			drawLines(event,true)
		StrokeMode.ROTATION_STROKE_2PI :
			drawLines(event,true)
		StrokeMode.ROTATION_STROKE_3PI :
			drawLines(event,true)


# func eraseStrokes() -> void:


func create_Joints(rb1, rb2, _angular_vel:float = 0.0 ):
	var joint:PinJoint2D = PinJoint2D.new()
	rb1[1].add_child(joint)
	joint.position = (rb1[0])
	joint.node_a = rb1[1].get_path()
	joint.node_b = rb2[1].get_path()
	joint.motor_enabled =true
	joint.motor_target_velocity = _angular_vel
	joint.disable_collision = true 
	joints.append(joint)
	
	


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
		rigidBody.collision_mask = 2 | 1

		# rigidBody.kine
		add_child(rigidBody)
		_rigidBodies.append(rigidBody)
		i = j + 1
		j = get_null(_lines, i)



func constructRigidBodiesRotatory(type:StrokeMode) -> void:
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
		rigidBody.collision_mask = 2 | 1

		# rigidBody.kine
		add_child(rigidBody)
		_rigidBodies.append(rigidBody)
		match type:
			StrokeMode.ROTATION_STROKE_PI:
				_RotatoryRbs_Type1.append(rigidBody)
			StrokeMode.ROTATION_STROKE_2PI:
				_RotatoryRbs_Type2.append(rigidBody)
			StrokeMode.ROTATION_STROKE_3PI:
				_RotatoryRbs_Type3.append(rigidBody)
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

	if _optionNode.get_selected_id() == StrokeMode.ERASER_STROKE:
		_mouse_axis_point_map.clear()
		var mouse_pos: Vector2i = get_global_mouse_position()
		if _rigidBodies.is_empty():
			return

		for j in len(_rigidBodies):
			var rb: RigidBody2D = _rigidBodies[j]
			var children: Array = rb.get_children()
			for i in range(1, children.size()):
				if children[i] is CollisionShape2D:
					var prev_pos = children[i-1].global_position
					var curr_pos = children[i].global_position

					if (in_between_x(prev_pos, curr_pos, mouse_pos) and in_between_y(prev_pos, curr_pos, mouse_pos)):
						var _pos = Vector2(mouse_pos.x, 0.5 * (prev_pos.y + curr_pos.y))
						_erasable_body = j
						draw_circle(_pos, 10, Color.RED)
	elif _optionNode.get_selected_id() == StrokeMode.JOINT_STROKE:
		_mouse_axis_point_map.clear()
		var mouse_pos: Vector2i = get_global_mouse_position()
		# print(mouse_pos)
		if _rigidBodies.is_empty():
			return

		var suitable_points_array: Array = []

		for j in len(_rigidBodies):
			var rb: RigidBody2D = _rigidBodies[j]
			var children: Array = rb.get_children()
			for i in range(1, children.size()):
				if children[i] is CollisionShape2D:
					var prev_pos = children[i-1].global_position
					var curr_pos = children[i].global_position

					if (in_between_x(prev_pos, curr_pos, mouse_pos)):
						var _pos = Vector2(mouse_pos.x, 0.5 * (prev_pos.y + curr_pos.y))
						suitable_points_array.append([_pos,rb])
						draw_circle(_pos, 10, Color.RED)
					if (in_between_y(prev_pos, curr_pos, mouse_pos)):
						var _pos = Vector2(0.5 * (prev_pos.x + curr_pos.x), mouse_pos.y)
						suitable_points_array.append([_pos,rb])
						draw_circle(_pos, 10, Color.RED)

		if not joints.is_empty():
			for joint in joints:
				draw_circle(joint.global_position,10,Color.GREEN)

		var rbIndices= get_2_closest_rb(mouse_pos, suitable_points_array)
		if(len(rbIndices) == 0):
			return
		var closest = rbIndices[0]
		var second_closest = rbIndices[1]

		draw_circle(closest[0],10,Color.PURPLE)
		draw_circle(second_closest[0],10,Color.PURPLE)
		_joinable_rigidbodies = [closest,second_closest]
		# for i in range(len(_rigidBodies)):
		# 	var line: Line2D = _get_line2D(_rigidBodies[i])
		# 	if i == closest or i == second_closest:
		# 		line.width = 10
		# 	else:
		# 		line.width = 3
	else:
		_erasable_body = -1



		

func _physics_process(delta):
	for rb in _RotatoryRbs_Type1:
		rb.angular_velocity = PI
	for rb in _RotatoryRbs_Type2:
		rb.angular_velocity = 4*PI
	for rb in _RotatoryRbs_Type3:
		rb.angular_velocity = 6*PI

func _process(delta: float) -> void:
	queue_redraw()
