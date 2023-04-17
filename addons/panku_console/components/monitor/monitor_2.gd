extends Control

signal change_window_title_text(text:String)

const N = 999999

@export var _label:RichTextLabel
@export var _trect:TextureRect

@export var title_text:String = ""
@export_range(0, 30) var update_frequency:int = 0
@export var expression:String = ""
@export var export_button_confirm = "Apply"
@export var export_comment_1 = "Hint: You can click the title to update result instantly"

var _update_period = N
var _update_exp = "engine.performance_info"
var t = 0.0

func update_exp_i():
	var value = Console.execute(_update_exp)["result"]
	if value is Texture2D:
		#Not sure about how texture works
		_trect.texture = ImageTexture.create_from_image(value.get_image())
	else:
		_label.text = str(value)

func _ready():
	t = _update_period
	update_frequency = round(1.0 / _update_period)
	expression = _update_exp

func _process(delta):
	t -= delta
	if t <= 0.0:
		update_exp_i()
		t += _update_period

func confirm():
	_update_exp = expression

	if update_frequency == 0:
		_update_period = N
	else:
		_update_period = 1.0 / update_frequency
	t = _update_period
	
	if title_text == "":
		change_window_title_text.emit(_update_exp)
	else:
		change_window_title_text.emit(title_text)

func get_content_data():
	return {
		"expression": expression,
		"update_interval": _update_period
	}
