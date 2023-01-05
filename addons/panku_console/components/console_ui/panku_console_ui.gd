extends Control

@onready var _console_logs = $VBoxContainer/ConsoleLogs
@onready var _menu_tools := $VBoxContainer/Menu/MenuBar/Tools
@onready var _menu_tools_exporttargets := $VBoxContainer/Menu/MenuBar/Tools/ExportTargets
@onready var _menu_options := $VBoxContainer/Menu/MenuBar/Options
@onready var _menu_info := $VBoxContainer/Menu/MenuBar/Info
@onready var _menu_options_transparency := $VBoxContainer/Menu/MenuBar/Options/Transparency
@onready var _network := $Network
@onready var _repl := $REPL

## Output [code]any[/code] to the console
func output(any):
	var text = str(any)
	_console_logs.add_log(text)

func clear_output():
	_console_logs.clear()

func check_latest_release():
	_network.check_latest_release()
	return "Checking latest release..."

func _ready():
	_menu_info.index_pressed.connect(
		func(index:int):
			#Show Intro
			if index == 0:
				Console.show_intro()
			#Check Update
			elif index == 1:
				Console.output(check_latest_release())
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
	_menu_options.id_pressed.connect(
		func(id:int):
			var index = _menu_options.get_item_index(id)
			#Pause when Active
			if id == 0:
				_menu_options.set_item_checked(index, !_menu_options.is_item_checked(index))
				Console.pause_when_active = _menu_options.is_item_checked(index)
				get_tree().paused = Console.pause_when_active
				Console._console_window.title_label.text = "> Panku REPL"
				if Console.pause_when_active:
					Console._console_window.title_label.text += " (Paused)"
			#No Resize
			elif id == 2:
				_menu_options.set_item_checked(index, !_menu_options.is_item_checked(index))
				Console._console_window.no_resize = _menu_options.is_item_checked(index)
			#No Move
			elif id == 3:
				_menu_options.set_item_checked(index, !_menu_options.is_item_checked(index))
				Console._console_window.no_move = _menu_options.is_item_checked(index)
	)
	_menu_options.set_item_submenu(_menu_options.get_item_index(1), "Transparency")
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
				_repl.execute("console.cls")
			#Add Profiler Widget
			elif index == 1:
				_repl.execute("widgets.profiler")
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
			_repl.execute("widgets.export_panel(%s)"%obj_name)
	)
	_network.response_received.connect(
		func(msg:Dictionary):
			if !msg["success"]:
				Console.notify("[color=red][Error][/color] Failed! " + msg["msg"])
				return
			Console.notify("[color=green][info][/color] Latest: [%s] [url=%s]%s[/url]" % [msg["published_at"], msg["html_url"], msg["name"]])
	)
