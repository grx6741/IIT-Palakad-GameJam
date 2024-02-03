extends Node2D

@export_range(0.0,2.0) var slope_collider_sensitivity: float

var in_draw_mode : bool = false
var has_skeleton : bool = false
var slope_last_frame = 0.0

func createCollider(rigidbody: RigidBody2D, length:float,angle:float,pos:Vector2):
	var collider : CollisionShape2D = CollisionShape2D.new()
	collider.shape = CapsuleShape2D.new()
	collider.rotation = PI/2 + angle
	collider.position = pos
	collider.shape.set_height(length)
	collider.shape.set_radius(3)
	rigidbody.add_child(collider)

func getDeltaSlope(_array : Array,index: int) -> float:
	return (_array[index+1].y - _array[index].y)/(_array[index+1].x - _array[index].x)

func getPos_Array(_array : Array, index:int) -> Vector2:
	return ((_array[index+1] + _array[index]))/2

func getLength_Line_Array(_array : Array,index : int) -> float:
	var dirVec : Vector2 = _array[index+1] - _array[index]
	return dirVec.length()

func handleColliderCreation(rigidbody: RigidBody2D, points_array) -> void:
	if(not in_draw_mode and not has_skeleton and len(points_array) > 1):
		var slope: float = getDeltaSlope(points_array,0)
		slope_last_frame = slope
		var length: float = getLength_Line_Array(points_array,0)
		var angle: float = 0.0
		var last_detPos : Vector2 = points_array[0]
		for i in range(1,len(points_array)-2):
			if(points_array[i] == null or points_array[i+1] == null):
				continue
			slope = getDeltaSlope(points_array,i)
			
			if(abs(slope_last_frame - slope) >= slope_collider_sensitivity):
				angle = atan(slope_last_frame)
				var col_position =  (points_array[i] + last_detPos)/2
				last_detPos = points_array[i]
				createCollider(rigidbody,length,angle,col_position)
				length = getLength_Line_Array(points_array,i)
			else:	
				length += getLength_Line_Array(points_array,i)
			
			slope_last_frame = slope
		angle = atan(slope_last_frame)
		createCollider(rigidbody, length,angle,(points_array[-1] + last_detPos)/2)
