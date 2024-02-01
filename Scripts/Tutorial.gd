extends CanvasLayer 

enum StrokeMode {
	NORMAL_STROKE,
	ERASER_STROKE,
	JOINT_STROKE,
	ROTATION_STROKE_PI,
	ROTATION_STROKE_2PI,
	ROTATION_STROKE_3PI
}

var _textbox: RichTextLabel
var _optionNode: OptionButton

var _instruction_array: Array
var _gen_instruction: String

func setInstructions():
	_instruction_array.resize(6)
	
	_gen_instruction = '''
	-> Left Click to Draw on canvas
	-> Click Clear to remove temp drawing and regain ink
	-> Hit Space Bar to confirm drawing and instill life
	-> Click Transform to let the show begin!
	'''
	_instruction_array[StrokeMode.NORMAL_STROKE]='''
	Stroke Mode -> NORMAL_STROKE
		Draw Stationary Objects
	'''

	_instruction_array[StrokeMode.ERASER_STROKE]='''
	Stroke Mode -> ERASER_STROKE
		Delete Stuff highlighted by Red
		Erasing Strokes Remove all Joints...
	'''

	_instruction_array[StrokeMode.JOINT_STROKE]='''
	Stroke Mode -> JOINT_STROKE
		Connect two nearby nodes highlighted by RED,
		press SPACE to confirm
	'''

	_instruction_array[StrokeMode.ROTATION_STROKE_PI]='''
	Stroke Mode -> ROTATION_STROKE_PI
		Rotates on confirmation at slow velocity
	'''

	_instruction_array[StrokeMode.ROTATION_STROKE_2PI]='''
	Stroke Mode -> ROTATION_STROKE_2PI
		Rotates on confirmation at medium velocity
	'''

	_instruction_array[StrokeMode.ROTATION_STROKE_3PI]='''
	Stroke Mode -> ROTATION_STROKE_3PI
		Rotates on confirmation at high velocity
	'''

func _ready():
	_textbox = $RichTextLabel
	_optionNode = get_node("../PlayerInterface/UI/DrawMenu/StrokeOptions")
	setInstructions()

func _process(_delta):
	_textbox.text = _gen_instruction +_instruction_array[_optionNode.get_selected_id()]
