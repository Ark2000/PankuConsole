## Panku Console. Provide a runtime GDScript REPL so your can run any script expressions in your game!
##
## This class will be an autoload ([code] Console [/code] by default) if you enable the plugin. The basic idea is that you can run [Expression] based on an environment(or base instance) by [method execute]. You can view [code]default_env.gd[/code] to see how to prepare your own environment.
## [br]
## [br] What's more, you can...
## [br]
## [br] ● Send in-game notifications by [method notify]
## [br] ● Output something to the console window by [method output]
## [br] ● Manage widgets plans by [method add_widget], [method save_current_widgets_as], etc.
## [br] ● Lot's of useful expressions defined in [code]default_env.gd[/code].
##
## @tutorial:            https://github.com/Ark2000/PankuConsole
class_name PankuConsole extends CanvasLayer

## Emitted when the visibility (hidden/visible) of console window changes.
signal console_window_visibility_changed(is_visible:bool)

## The input action used to toggle console. By default it is KEY_QUOTELEFT.
var toggle_console_action:String

## If [code]true[/code], pause the game when the console window is active.
var pause_when_active:bool

@onready var _resident_logs = $ResidentLogs
@onready var _console_window = $LynxWindows/ConsoleWindow
@onready var _console_ui = $LynxWindows/ConsoleWindow/Body/Content/PankuConsoleUI
@onready var _base_instance = $BaseInstance
@onready var _windows = $LynxWindows

const _monitor_widget_pck = preload("res://addons/panku_console/components/widgets2/monitor_widget.tscn")
const _export_widget_pck = preload("res://addons/panku_console/components/widgets2/export_widget.tscn")

var _envs = {}
var _envs_info = {}
var _expression = Expression.new()

## Returns whether the console window is opened.
func is_console_window_opened():
	return _console_window.visible

## Register an environment that run expressions.
## [br][code]env_name[/code]: the name of the environment
## [br][code]env[/code]: The base instance that runs the expressions. For exmaple your player node.
func register_env(env_name:String, env:Object):
	_envs[env_name] = env
	output("[color=green][Info][/color] [b]%s[/b] env loaded!"%env_name)
	if env is Node:
		env.tree_exiting.connect(
			func(): remove_env(env_name)
		)
	if env.get_script():
		var env_info = PankuUtils.extract_info_from_script(env.get_script())
		for k in env_info:
			var keyword = "%s.%s" % [env_name, k]
			_envs_info[keyword] = env_info[k]

## Return the environment object or [code]null[/code] by its name.
func get_env(env_name:String) -> Node:
	return _envs.get(env_name)

## Remove the environment named [code]env_name[/code]
func remove_env(env_name:String):
	if _envs.has(env_name):
		_envs.erase(env_name)
		for k in _envs_info.keys():
			if k.begins_with(env_name + "."):
				_envs_info.erase(k)
	notify("[color=green][Info][/color] [b]%s[/b] env unloaded!"%env_name)

## Generate a notification
func notify(any) -> void:
	var text = str(any)
	_resident_logs.add_log(text)
	output(text)

func output(any) -> void:
	_console_ui.output(any)

#This only return the expression result
func execute(exp:String) -> Dictionary:
#	print(exp)
	var failed := false
	var result
	var error = _expression.parse(exp, _envs.keys())
	if error != OK:
		failed = true
		result = _expression.get_error_text()
	else:
		result = _expression.execute(_envs.values(), _base_instance, true)
		if _expression.has_execute_failed():
			failed = true
			result = _expression.get_error_text()
	return {
		"failed": failed,
		"result": result
	}

func add_widget2(exp:String, update_period:= 999999.0, position:Vector2 = Vector2(0, 0), size:Vector2 = Vector2(160, 60), title_text := ""):
	if title_text == "": title_text = exp
	var w = _monitor_widget_pck.instantiate()
	w.position = position
	w.size = size
	w.update_exp = exp
	w.update_period = update_period
	w.title_text = title_text
	_windows.add_child(w)

func add_export_widget(obj:Object):
	var obj_name = _envs.find_key(obj)
	if obj_name == null:
		return
	if !obj.get_script():
		return
	var export_properties = PankuUtils.get_export_properties_from_script(obj.get_script())
	if export_properties.is_empty():
		return
	var w = _export_widget_pck.instantiate()
	_windows.add_child(w)
	w.setup(obj, export_properties)
	w.position = Vector2(0, 0)
	w.size = Vector2(160, 60)
	w.title_label.text = "Export Properties (%s)"%str(obj)
	w.set_meta("obj_name", obj_name)
	return w

func get_available_export_objs() -> Array:
	var result = []
	for obj_name in _envs:
		var obj = _envs[obj_name]
		if !obj.get_script():
			continue
		var export_properties = PankuUtils.get_export_properties_from_script(obj.get_script())
		if export_properties.is_empty():
			continue
		result.push_back(obj_name)
	return result

func show_intro():
	output("[center][img=96]res://addons/panku_console/logo.svg[/img][/center]")
	output("[b][color=burlywood][ Panku Console ][/color][/b]")
	output("[color=burlywood][b][color=burlywood]Version 1.2.31[/color][/b][/color]")
	output("[color=burlywood][b]Check [color=green]repl_console_env.gd[/color] or simply type [color=green]help[/color] to see what you can do now![/b][/color]")
	output("[color=burlywood][b]For more info, please visit: [color=green][url=https://github.com/Ark2000/PankuConsole]project github page[/url][/color][/b][/color]")
	output("")

func _input(_e):
	if Input.is_action_just_pressed(toggle_console_action):
		_console_ui._input_area.input.editable = !_console_window.visible
		await get_tree().process_frame
		_console_window.visible = !_console_window.visible

func _ready():
	assert(get_tree().current_scene != self, "Do not run this directly")

	show_intro()

	pause_when_active = ProjectSettings.get("panku/pause_when_active")
	toggle_console_action = ProjectSettings.get("panku/toggle_console_action")
	
	print(PankuConfig.get_config())
	_console_window.hide()
	_console_window.visibility_changed.connect(
		func():
			console_window_visibility_changed.emit(_console_window.visible)
			if pause_when_active:
				get_tree().paused = _console_window.visible
				_console_window.title_label.text = "> Panku REPL (Paused)"
			else:
				_console_window.title_label.text = "> Panku REPL"
	)
	#check the action key
	#the open console action can be change in the export options of panku.tscn
	assert(InputMap.has_action(toggle_console_action), "Please specify an action to open the console!")

	#add info of base instance
	var env_info = PankuUtils.extract_info_from_script(_base_instance.get_script())
	for k in env_info: _envs_info[k] = env_info[k]
	
	#load configs
	var cfg = PankuConfig.get_config()

	if cfg.has("widgets_data"):
		var w_data = cfg["widgets_data"]
		for w in w_data:
			add_widget2(w["exp"], w["period"], w["position"], w["size"], w["title"])
		cfg["widgets_data"] = []
	
	await get_tree().process_frame
	
	if cfg.has("init_exp"):
		var init_exp = cfg["init_exp"]
		for e in init_exp:
			_console_ui.execute(e)
		cfg["init_exp"] = []
		
	await get_tree().process_frame
	
	if cfg.has("repl"):
		_console_window.visible = cfg.repl.visible
		_console_window.position = cfg.repl.position
		_console_window.size = cfg.repl.size

	PankuConfig.set_config(cfg)

func _notification(what):
	#quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var cfg = PankuConfig.get_config()
		if !cfg.has("repl"):
			cfg["repl"] = {
				"visible":false,
				"position":Vector2(0, 0),
				"size":Vector2(200, 200)
			}
		cfg.repl.visible = _console_window.visible
		cfg.repl.position = _console_window.position
		cfg.repl.size = _console_window.size
		PankuConfig.set_config(cfg)
