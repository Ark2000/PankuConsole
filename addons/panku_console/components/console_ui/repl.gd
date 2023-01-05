extends Node

@export var _input_area:Control
@export var _hints:Control
@export var _helpbar:Control
@export var _helpbar_label:Control
@export_enum("output", "notify") var _output_method := 0

var _current_hints := {}
var _hint_idx := 0
func _set_hint_idx(v):
		_hint_idx = v
		if _current_hints["hints_value"].size() > 0:
			v = wrapi(v, 0, _current_hints["hints_value"].size())
			var k = _current_hints["hints_value"][v]
			_hint_idx = v
			_hints.selected = v
			_input_area.input.text = k
			_input_area.input.caret_column = k.length()
			_helpbar_label.text = "[Help] %s" %  Console._envs_info[k]["help"]

func execute(exp:String):
	var output_result_method = [Console.output, Console.notify][_output_method]
	exp = exp.lstrip(" ").rstrip(" ")
	if exp.is_empty():
		return
	Console.output(exp)
	var result = Console.execute(exp)
	if !result["failed"]:
		output_result_method.call("> %s"%str(result["result"]))
	else:
		output_result_method.call("> [color=red]%s[/color]"%(result["result"]))

func _ready():
	_input_area.submitted.connect(execute)
	_input_area.update_hints.connect(
		func(exp:String):
			_current_hints = PankuConsole.Utils.parse_exp(Console._envs_info, exp)
			_hints.visible = _current_hints["hints_value"].size() > 0
			_helpbar.visible = _hints.visible
			_input_area.input.hints = _current_hints["hints_value"]
			_hints.disable_buttons = false
			_hints.set_hints(_current_hints["hints_bbcode"], _current_hints["hints_icon"])
			_hint_idx = -1
			_helpbar_label.text = "[Hint] Use TAB or up/down to autocomplete!"
	)
	_input_area.next_hint.connect(
		func():
			_set_hint_idx(_hint_idx + 1)
	)
	_input_area.prev_hint.connect(
		func():
			if _hint_idx == -1:
				_hint_idx = 0
			_set_hint_idx(_hint_idx - 1)
	)
	_input_area.navigate_histories.connect(
		func(histories, id):
			if histories.size() > 0:
				_hints.disable_buttons = true
				_hints.set_hints(histories, [])
				_hints.selected = id
				_hints.visible = true
			else:
				_hints.visible = false
			_helpbar.visible = _hints.visible
			_helpbar_label.text = "[Hint] Use up/down to navigate through submit histories!"

	)
	_hints.hint_button_clicked.connect(
		func(i:int):
			_set_hint_idx(i)
	)
	
	_helpbar.hide()
	_hints.hide()
