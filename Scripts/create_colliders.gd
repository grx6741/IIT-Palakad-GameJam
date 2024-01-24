extends Node2D
# @export var points_array : Array
@export_range(0.0,2.0) var slope_collider_sensitivity:float

var in_draw_mode : bool = false
var has_skeleton : bool = false
var slope_last_frame = 0.0

func _ready():	
	# slope_last_frame = 0.0
	pass 

func createCollider(rigidbody: RigidBody2D, length:float,angle:float,pos:Vector2):
	print(rigidbody.name)
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
				# print_debug(rad_to_deg(angle))
				var col_position =  (points_array[i] + last_detPos)/2
				last_detPos = points_array[i]
				createCollider(rigidbody,length,angle,col_position)
				length = getLength_Line_Array(points_array,i)
			else:	
				length += getLength_Line_Array(points_array,i)
			
			slope_last_frame = slope
		angle = atan(slope_last_frame)
		createCollider(rigidbody, length,angle,(points_array[-1] + last_detPos)/2)
		# has_skeleton = true

'''
func _process(delta):
	handleColliderCreation()
	

func _draw() -> void:
	draw_circle(points_array[0],10.0,Color.BLACK)
	var slope: float = 0.0
	var length: float = 0.0
	for i in range(len(points_array)-1):
		if(points_array[i] == null or points_array[i+1] == null):
			continue
		slope = (points_array[i+1].y - points_array[i].y)/(points_array[i+1].x - points_array[i].x)
		length = sqrt((points_array[i+1].x - points_array[i].x)**2 + (points_array[i+1].y - points_array[i].y)**2)
		#print_debug("slope = ", slope, " length = ",length)
		draw_line(points_array[i], points_array[i+1], Color.BLACK,20.0)
	draw_circle(points_array[-1],10.0,Color.BLACK)
'''
