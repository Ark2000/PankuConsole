extends Control

signal change_window_title_text(text:String)

const N = 999999

@export var _label:RichTextLabel

@export var title_text:String = ""
@export_range(0, 30) var update_frequency:int = 0
@export var expression:String = ""
@export var export_button_confirm = "Apply"

var _update_period = N
var _update_exp = "engine.performance_info"
var t = 0.0

func update_exp_i():
	_label.text = str(Console.execute(_update_exp)["result"])

func _ready():
	t = _update_period
	update_frequency = round(1.0 / _update_period)
	expression = _update_exp

func _process(delta):
	t -= delta
	if t <= 0.0:
		_label.text = str(Console.execute(_update_exp)["result"])
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
