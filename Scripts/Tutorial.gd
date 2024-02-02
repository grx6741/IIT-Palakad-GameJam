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
var _tip_instruction: Array
var cur_rand_tip: String

func setInstructions():
	_instruction_array.resize(6)
	
	_tip_instruction = [
		'Carefully Time the FREEZE and TRANSFORM Clicks.',
		'During FREEZE, Modify the Drawing to Suit the Best Outcome.',
		'The Rotatory Nodes always move in Clockwise Direction.',
		'Put Joints with Care.',
		'Unnecessary Strokes and Joints can cause the Heart to Escape the Matrix.',
		'Your Creativity is the Limit.',
		'Restart the Level if you Encounter any \"Dead Ends\".',
		'Use FREEZE as a Potential PAUSE Button if Required.'
	]
	
	_gen_instruction = '''
	OBJECTIVE:
	> The Game consists of Five Levels.
	> Every Level has an Incomplete Heart which needs another Heart for Love to Prosper...
	> Draw a Temporary Body for the Heart to Navigate Obstacles and Reach the other Heart.
	
	INSTRUCTIONS:
	> LEFT CLICK to Draw on the Canvas.
	> Keep an Eye on the Ink Level of the Pen.
	> Click CLEAR to Remove Temporary Drawing and Regain its Ink.
	> Hit SPACE BAR to Confirm Drawing and Instill Life.
	> Click TRANSFORM to Let the Physics do its Job!
	> During the Real-Time Physics Mode, Click FREEZE to Modify the Drawing.
	'''
	
	_instruction_array[StrokeMode.NORMAL_STROKE]='''
	Mode < STATIC STROKE >
		Draw Stationary Objects.
		NOTE: You must Cover the Heart with Static Stroke.  
	'''

	_instruction_array[StrokeMode.ERASER_STROKE]='''
	Mode < REMOVE STROKE >
		Delete Stuff Highlighted by Red.
		Press SPACE BAR to Confirm.
		NOTE: Erasing Strokes Removes all of its Joints.
	'''

	_instruction_array[StrokeMode.JOINT_STROKE]='''
	Mode < JOINT MODE >
		Connect 2 nearby Nodes Highlighted by RED.
		Press SPACE BAR to Confirm.
	'''

	_instruction_array[StrokeMode.ROTATION_STROKE_PI]='''
	Mode < ROTATORY STROKE @ PI >
		Rotates on Confirmation at Slow Velocity.
	'''

	_instruction_array[StrokeMode.ROTATION_STROKE_2PI]='''
	Mode < ROTATORY STROKE @ 2PI >
		Rotates on Confirmation at Medium Velocity.
	'''

	_instruction_array[StrokeMode.ROTATION_STROKE_3PI]='''
	Mode < ROTATORY STROKE @ 3PI >
		Rotates on Confirmation at High Velocity.
	'''

func _ready():
	_textbox = $Panel/RichTextLabel
	_optionNode = get_node("../PlayerInterface/UI/DrawMenu/StrokeOptions")
	setInstructions()
	var tipRand = randi_range(0, 7)
	cur_rand_tip = _tip_instruction[tipRand]

var time = 0 
func generateRandTip():
	var tipRand = randi_range(0, 6)
	if time > 10:
		cur_rand_tip = _tip_instruction[tipRand]
		time = 0

func _process(_delta):
	_textbox.text = _gen_instruction +_instruction_array[_optionNode.get_selected_id()]
	time += _delta
	generateRandTip()
	_textbox.text += "\nTIP: " + cur_rand_tip
