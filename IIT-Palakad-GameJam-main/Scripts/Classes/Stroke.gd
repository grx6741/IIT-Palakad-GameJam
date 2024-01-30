extends "res://Scripts/create_colliders.gd"

class Stroke:
	var points: PackedVector2Array = []

	func length() -> int:
		return len(points)
	
	func add_point(point: Vector2) -> void:
		points.append(point)

	func is_point_in(point: Vector2) -> bool:
		for p in points:
			if p == point:
				return true
		return false