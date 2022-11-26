class_name PankuImpl extends CanvasLayer

signal console_window_visibility_changed(is_visible:bool)

@export var open_console_action = "open_console"
@export var draggable_window := true:
	set(v):
		draggable_window = v
		if _window: _window.draggable = v
@export var resizable_window := true:
	set(v):
		resizable_window = v
		if _window: _window.resizable = v

@onready var _resident_logs = $ResidentLogs
@onready var _console_logs = $LynxWindow/Content/ConsoleLogs
@onready var _window = $LynxWindow
@onready var _input_area = $LynxWindow/Content/InputArea
@onready var _glow = $GlowEffect/ColorRect

var _envs = {}
var _expression = Expression.new()

func is_console_window_opened():
	return _window.visible

func register_env(env_name:String, env):
	_envs[env_name] = env
	_input_area.add_option(env_name)
	notify("[color=green][Info][/color] [b]%s[/b] env loaded!"%env_name)

func remove_env(env_name:String):
	if _envs.has(env_name):
		_envs.erase(env_name)
	_input_area.remove_option(env_name)
	notify("[color=green][Info][/color] [b]%s[/b] env unloaded!"%env_name)

func output(bbcode:String):
	_console_logs.add_log(bbcode)
	print(bbcode)

func notify(bbcode:String):
	_resident_logs.add_log(bbcode)
	_console_logs.add_log(bbcode)
	print(bbcode)

func _input(_e):
	if Input.is_action_just_pressed(open_console_action) and !_input_area.input.has_focus():
		await get_tree().process_frame
		_window.visible = !_window.visible

func _process(d):
	_glow.size = _console_logs.size
	_glow.position = _console_logs.global_position

func _ready():
	output("[b][color=burlywood][ Panku Console ][/color][/b]")
	output("[color=burlywood][b][color=burlywood]Version 1.0.1[/color][/b][/color]")
	output("[color=burlywood][b]Check [color=green]default_env.gd[/color] or simply type [color=green]help[/color] to see what you can do now![/b][/color]")
	output("[color=burlywood][b]For more info, please visit: [color=green][url=https://github.com/Ark2000/PankuConsole]project github page[/url][/color][/b][/color]")
	output("")

	_input_area.clear_options()
	_input_area.submitted.connect(
		func(env:String, exp:String):
			output("[%s] %s"%[env, exp])
			var obj = _envs[env]
			var error = _expression.parse(exp)
			if error != OK:
				output(_expression.get_error_text())
				return
			var result = _expression.execute([], obj)
			if not _expression.has_execute_failed():
				output("[color=green][Result][/color] " + str(result))
			else:
				output("[color=red]Execution failed![/color]")
	)

	_window.hide()
	_window.draggable = draggable_window
	_window.resizable = resizable_window
	_window.visibility_changed.connect(
		func():
			console_window_visibility_changed.emit(_window.visible)
	)
	
	#check the action key
	#the open console action can be change in the export options of panku.tscn
	assert(InputMap.has_action(open_console_action), "Please specify an action to open the console!")
