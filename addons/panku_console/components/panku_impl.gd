class_name PankuImpl extends CanvasLayer

const CONSOLE_KEY = KEY_QUOTELEFT

@onready var _resident_logs = $ResidentLogs
@onready var _console_logs = $LynxWindow/Content/ConsoleLogs
@onready var _window = $LynxWindow
@onready var _input_area = $LynxWindow/Content/InputArea
@onready var _glow = $GlowEffect/ColorRect

var _envs = {}
var _expression = Expression.new()

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

func _input(e):
	if e is InputEventKey and e.keycode == CONSOLE_KEY and e.pressed:
		await get_tree().process_frame
		_window.is_visible = !_window.is_visible

func _process(d):
	_glow.size = _console_logs.size
	_glow.position = _console_logs.global_position

func _ready():
	_window.hide()
	
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
