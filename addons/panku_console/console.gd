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
@export var toggle_console_action := "toggle_console"

## If [code]true[/code], pause the game when the console window is active.
@export var pause_when_active := true

@onready var _resident_logs = $ResidentLogs
@onready var _console_window = $LynxWindows/ConsoleWindow
@onready var _console_ui = $LynxWindows/ConsoleWindow/Body/Content/PankuConsoleUI
@onready var _widgets = $Widgets
@onready var _base_instance = $BaseInstance

const _floating_widget_pck = preload("res://addons/panku_console/components/floating_widget/floating_widget.tscn")

var _envs = {}
var _envs_info = {}
var _expression = Expression.new()
var _config = PankuConfig.get_config()

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

## Add a new widget to current widgets plan.
## [br]The [code]update_exp[/code] will be executed every [code]update_delay[/code] seconds and the result will be used as display text.
## [br]The [code]pressed_exp[/code] will be executed when the widget is clicked.
func add_widget(update_delay:float, update_exp:String, pressed_exp:String, position:Vector2):
	var w = _add_widget(update_delay, update_exp, pressed_exp, position)
	save_current_widgets_as(_config["widgets_system"]["current_plan"])
	return w

func _add_widget(update_delay:float, update_exp:String, pressed_exp:String, position:Vector2):
	var new_widget = _floating_widget_pck.instantiate()
	_widgets.add_child(new_widget)
	new_widget.update_delay = update_delay
	new_widget.get_widget_text = func(): return execute(update_exp)["result"]
	new_widget.btn_pressed = func(): if !pressed_exp.is_empty(): execute(pressed_exp)
	new_widget.position = position
	new_widget.start()
	new_widget.set_meta("info",{
		"update_delay": update_delay,
		"update_exp": update_exp,
		"pressed_exp": pressed_exp,
		"position": position
	})
	#update config when deleting a widget
	new_widget.close_btn.pressed.connect(
		func():
			await get_tree().process_frame
			save_current_widgets_as(_config["widgets_system"]["current_plan"])
	)
	return new_widget

## Return a Dictionary contains all widgets plans.
func get_widgets_plans() -> Dictionary:
	return _config["widgets_system"]

## Load a widgets plan
func load_widgets_plan(plan:String):
	var plans = _config["widgets_system"]["plans"]

	#do not have this plan
	if !plans.has(plan):
		return false

	#prepare to load this plan

	#save current
	if _config["widgets_system"]["current_plan"] != plan:
		save_current_widgets_as(_config["widgets_system"]["current_plan"])

	#clear all existing widgets
	for w in _widgets.get_children():
		w.queue_free()

	#load widgets
	for winfo in plans[plan]:
		_add_widget(
			winfo.get("update_delay", 1.0),
			winfo.get("update_exp", ""),
			winfo.get("pressed_exp", ""),
			winfo.get("position", Vector2(0, 0))
		)

	_config["widgets_system"]["current_plan"] = plan

	notify("[color=green][Info][/color] [b]%s[/b] widgets plan loaded!" % plan)

	return true

## Save current widgets plan as a new plan.
func save_current_widgets_as(plan:String):
	var d = []
	for w in _widgets.get_children():
		d.append(w.get_meta("info"))
	_config["widgets_system"]["plans"][plan] = d
	_config["widgets_system"]["current_plan"] = plan

## Delete a widgets plan(except current)
func delete_widgets_plan(plan:String):
	if plan == _config["widgets_system"]["current_plan"]:
		return false
	_config["widgets_system"]["plans"].erase(plan)
	return true

func _input(_e):
	if Input.is_action_just_pressed(toggle_console_action):
		_console_ui._input_area.input.editable = !_console_window.visible
		await get_tree().process_frame
		_console_window.visible = !_console_window.visible

func _ready():
	assert(get_tree().current_scene != self, "Do not run this directly")

	_console_window.hide()
	_console_window.visibility_changed.connect(
		func():
			console_window_visibility_changed.emit(_console_window.visible)
			if pause_when_active:
				get_tree().paused = _console_window.visible
	)
	#check the action key
	#the open console action can be change in the export options of panku.tscn
	assert(InputMap.has_action(toggle_console_action), "Please specify an action to open the console!")
	
	#add info of base instance
	var env_info = PankuUtils.extract_info_from_script(_base_instance.get_script())
	for k in env_info: _envs_info[k] = env_info[k]

	#load widgets plan last time
	await get_tree().create_timer(1.0).timeout
	load_widgets_plan(_config["widgets_system"]["current_plan"])

func _notification(what):
	#quit event
	if what == 1006:
		#save back config
		save_current_widgets_as(_config["widgets_system"]["current_plan"])
		PankuConfig.set_config(_config)
