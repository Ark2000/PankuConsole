extends Control

@onready var _console_logs = $VBoxContainer/ConsoleLogs
@onready var _input_area = $VBoxContainer/InputArea
@onready var _hints = $HintsList
@onready var _helpbar = $HelpBar
@onready var _helpbar_label = $HelpBar/Label
@onready var _menu_widget:PopupMenu = $VBoxContainer/Menu/MenuBar/Widget
@onready var _menu_help:PopupMenu = $VBoxContainer/Menu/MenuBar/Help

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


## Output [code]any[/code] to the console
func output(any):
	var text = str(any)
	_console_logs.add_log(text)

func clear_output():
	_console_logs.clear()

func _ready():
	output("[b][color=burlywood][ Panku Console ][/color][/b]")
	output("[color=burlywood][b][color=burlywood]Version 1.1.23[/color][/b][/color]")
	output("[color=burlywood][b]Check [color=green]engine_env.gd[/color] or simply type [color=green]help[/color] to see what you can do now![/b][/color]")
	output("[color=burlywood][b]For more info, please visit: [color=green][url=https://github.com/Ark2000/PankuConsole]project github page[/url][/color][/b][/color]")
	output("")

	_input_area.submitted.connect(
		func(exp:String):
			exp = exp.lstrip(" ").rstrip(" ")
			if exp.is_empty():
				return
			var result = Console.execute(exp)
			output(exp)
			if !result["failed"]:
				output("> %s"%str(result["result"]))
			else:
				output("> [color=red]%s[/color]"%(result["result"]))
	)
	_input_area.update_hints.connect(
		func(exp:String):
			_current_hints = PankuUtils.parse_exp(Console._envs_info, exp)
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

	_menu_widget.id_pressed.connect(
		func(id):
			output("Sorry, WIP!")
			output("But you can use exp to manage widgets currently!")
	)
	_menu_help.id_pressed.connect(
		func(id):
			output("Sorry, WIP!")
	)
