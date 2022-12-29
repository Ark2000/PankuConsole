extends Control

@onready var _console_logs = $VBoxContainer/ConsoleLogs
@onready var _input_area = $VBoxContainer/Bottom/InputArea
@onready var _hints = $HintsList
@onready var _helpbar = $HelpBar
@onready var _helpbar_label = $HelpBar/Label
@onready var _menu_tools := $VBoxContainer/Menu/MenuBar/Tools
@onready var _menu_tools_exporttargets := $VBoxContainer/Menu/MenuBar/Tools/ExportTargets
@onready var _menu_options := $VBoxContainer/Menu/MenuBar/Options
@onready var _menu_info := $VBoxContainer/Menu/MenuBar/Info
@onready var _menu_options_transparency := $VBoxContainer/Menu/MenuBar/Options/Transparency

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
	
func execute(exp:String):
	exp = exp.lstrip(" ").rstrip(" ")
	if exp.is_empty():
		return
	var result = Console.execute(exp)
	output(exp)
	if !result["failed"]:
		output("> %s"%str(result["result"]))
	else:
		output("> [color=red]%s[/color]"%(result["result"]))

func _ready():

	_input_area.submitted.connect(execute)
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
	
	_menu_info.index_pressed.connect(
		func(index:int):
			#Show Intro
			if index == 0:
				Console.show_intro()
			#Report a Bug
			elif index == 2:
				OS.shell_open("https://github.com/Ark2000/PankuConsole/issues")
			#Suggest a Feature
			elif index == 3:
				OS.shell_open("https://github.com/Ark2000/PankuConsole/issues")
			#Community
			elif index == 4:
				OS.shell_open("https://github.com/Ark2000/PankuConsole/discussions")
	)
	_menu_options.index_pressed.connect(
		func(index:int):
			#Pause when Active
			if index == 0:
				_menu_options.set_item_checked(index, !_menu_options.is_item_checked(index))
				Console.pause_when_active = _menu_options.is_item_checked(index)
				get_tree().paused = Console.pause_when_active
				Console._console_window.title_label.text = "> Panku REPL"
				if Console.pause_when_active:
					Console._console_window.title_label.text += " (Paused)"
			#No Resize
			elif index == 1:
				_menu_options.set_item_checked(index, !_menu_options.is_item_checked(index))
				Console._console_window.no_resize = _menu_options.is_item_checked(index)
			#No Move
			elif index == 2:
				_menu_options.set_item_checked(index, !_menu_options.is_item_checked(index))
				Console._console_window.no_move = _menu_options.is_item_checked(index)
	)
	_menu_options.set_item_submenu(3, "Transparency")
	#Not sure what is the cause of the error.
	#window_get_popup_safe_rect: Condition "!windows.has(p_window)" is true. Returning: Rect2i()
	_menu_options_transparency.index_pressed.connect(
		func(index:int):
			if index == 0:
				Console._console_window.transparency = 1.0
			elif index == 1:
				Console._console_window.transparency = 0.75
			elif index == 2:
				Console._console_window.transparency = 0.5
			elif index == 3:
				Console._console_window.transparency = 0.25
			elif index == 4:
				Console._console_window.transparency = 0.0
	)
	_menu_tools.index_pressed.connect(
		func(index:int):
			#Clear REPL Output
			if index == 0:
				execute("console.cls")
			#Add Profiler Widget
			elif index == 1:
				execute("widgets.profiler")
			#Add Export Properties Widget
			elif index == 2:
				pass
	)
	_menu_tools.set_item_submenu(2, "ExportTargets")
	_menu_tools.about_to_popup.connect(
		func():
			_menu_tools_exporttargets.clear()
			var objs = Console.get_available_export_objs()
			if objs.is_empty():
				_menu_tools_exporttargets.add_item("Not available")
				_menu_tools_exporttargets.set_item_disabled(0, true)
			else:
				for i in range(objs.size()):
					_menu_tools_exporttargets.add_item(objs[i])
	)
	_menu_tools_exporttargets.index_pressed.connect(
		func(index:int):
			var obj_name = _menu_tools_exporttargets.get_item_text(index)
			execute("widgets.export_panel(%s)"%obj_name)
	)
