## Panku Console. Provide a runtime console so your can run any script expressions in your game!
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

## If [code]true[/code], the user can drag the console window.
@export var draggable_window := true:
	set(v):
		draggable_window = v
		if _window: _window.draggable = v

## If [code]true[/code], the user can resize the console window.
@export var resizable_window := true:
	set(v):
		resizable_window = v
		if _window: _window.resizable = v

## If [code]true[/code], pause the game when the console window is active.
@export var pause_when_active := true

@onready var _resident_logs = $ResidentLogs
@onready var _console_logs = $LynxWindow/Content/ConsoleLogs
@onready var _window = $LynxWindow
@onready var _input_area = $LynxWindow/Content/InputArea
@onready var _glow = $GlowEffect/ColorRect
@onready var _widgets = $Widgets
@onready var _hints = $LynxWindow/Content/HintsList
@onready var _helpbar = $LynxWindow/Content/HelpBar
@onready var _helpbar_label = $LynxWindow/Content/HelpBar/RichTextLabel

const _floating_widget_pck = preload("res://addons/panku_console/components/floating_widget/floating_widget.tscn")

var _envs = {}
var _expression = Expression.new()
var _config = PankuConfig.get_config()
var _current_hints := {}
var _hint_idx := 0
var _current_env := "default"
func _set_hint_idx(v):
		_hint_idx = v
		if _current_hints["hints_value"].size() > 0:
			v = wrapi(v, 0, _current_hints["hints_value"].size())
			var k = _current_hints["hints_value"][v]
			_hint_idx = v
			_hints.selected = v
			_input_area.input.text = k
			_input_area.input.caret_column = k.length()
			var env_info = _envs[_current_env].get_meta("panku_env_info")
			_helpbar_label.text = " [b][color=green][Help][/color][/b] [i]%s[/i]" %  env_info[k]["help"]

## Returns whether the console window is opened.
func is_console_window_opened():
	return _window.visible

## Register an environment that run expressions.
## [br][code]env_name[/code]: the name of the environment
## [br][code]env[/code]: The base instance that runs the expressions. For exmaple your player node.
func register_env(env_name:String, env:Object):
	_envs[env_name] = env
	_input_area.add_option(env_name)
	notify("[color=green][Info][/color] [b]%s[/b] env loaded!"%env_name)
	if env is Node:
		env.tree_exiting.connect(
			func(): remove_env(env_name)
		)
	if env.get_script():
		env.set_meta("panku_env_info", PankuUtils.extract_info_from_script(env.get_script()))

## Return the environment object or [code]null[/code] by its name.
func get_env(env_name:String) -> Node:
	return _envs.get(env_name)

## Remove the environment named [code]env_name[/code]
func remove_env(env_name:String):
	if _envs.has(env_name):
		_envs.erase(env_name)
	_input_area.remove_option(env_name)
	notify("[color=green][Info][/color] [b]%s[/b] env unloaded!"%env_name)

## Output [code]bbcode[/code] to the console window
func output(bbcode:String):
	_console_logs.add_log(bbcode)

## Generate a notification
func notify(bbcode:String) -> void:
	_resident_logs.add_log(bbcode)
	_console_logs.add_log(bbcode)

## This is exactly what happened when you submit something in the console window.
func execute(env:String, exp:String):
	var result = _execute(env, exp)
	output("[%s] %s"%[env, exp])
	if !result["failed"]:
		output("> %s"%str(result["result"]))
	else:
		output("> [color=red]%s[/color]"%(result["result"]))

#This only return the expression result
func _execute(env:String, exp:String) -> Dictionary:
	var failed := false
	var result
	var obj = _envs[env]
	var error = _expression.parse(exp)
	if error != OK:
		failed = true
		result = _expression.get_error_text()
	else:
		result = _expression.execute([], obj)
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
func add_widget(update_delay:float, env:String, update_exp:String, pressed_exp:String, position:Vector2):
	var w = _add_widget(update_delay, env, update_exp, pressed_exp, position)
	save_current_widgets_as(_config["widgets_system"]["current_plan"])
	return w

func _add_widget(update_delay:float, env:String, update_exp:String, pressed_exp:String, position:Vector2):
	var new_widget = _floating_widget_pck.instantiate()
	_widgets.add_child(new_widget)
	new_widget.update_delay = update_delay
	new_widget.get_widget_text = func(): return _execute(env, update_exp)["result"]
	new_widget.btn_pressed = func(): if !pressed_exp.is_empty(): execute(env, pressed_exp)
	new_widget.position = position
	new_widget.start()
	new_widget.set_meta("info",{
		"update_delay": update_delay,
		"env": env,
		"update_exp": update_exp,
		"pressed_exp": pressed_exp,
		"position": position
	})
	#update config when deleting a widget
	new_widget.close_btn.pressed.connect(
		func():
			await get_tree().process_frame
			save_current_widgets_as(_config["widgets_system"]["current_plan"])
			print("saved!")
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
			winfo.get("env", "default"),
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

## Let's dance!
func party_time():
	_window.material.set("shader_parameter/fancy", 0.1)

func _input(_e):
	if Input.is_action_just_pressed(toggle_console_action):
		_input_area.input.editable = !_window.visible
		await get_tree().process_frame
		_window.visible = !_window.visible

func _process(d):
	_glow.size = _console_logs.size
	_glow.position = _console_logs.global_position

func _ready():
	assert(get_tree().current_scene != self, "Do not run this directly")

	output("[b][color=burlywood][ Panku Console ][/color][/b]")
	output("[color=burlywood][b][color=burlywood]Version 1.1.23[/color][/b][/color]")
	output("[color=burlywood][b]Check [color=green]default_env.gd[/color] or simply type [color=green]help[/color] to see what you can do now![/b][/color]")
	output("[color=burlywood][b]For more info, please visit: [color=green][url=https://github.com/Ark2000/PankuConsole]project github page[/url][/color][/b][/color]")
	output("")

	_input_area.clear_options()
	_input_area.submitted.connect(execute)
	_input_area.update_hints.connect(
		func(env:String, exp:String):
			var info = _envs[env].get_meta("panku_env_info")
			_current_hints = PankuUtils.parse_exp(info, exp)
			_hints.visible = _current_hints["hints_value"].size() > 0
			_helpbar.visible = _hints.visible
			_input_area.input.hints = _current_hints["hints_value"]
			_hints.disable_buttons = false
			_hints.set_hints(_current_hints["hints_bbcode"], _current_hints["hints_icon"])
			_hint_idx = -1
			_helpbar_label.text = " [b][color=green][Hint][/color][/b] Use [b]TAB[/b] or [b]up/down[/b] to autocomplete!"
	)
	_input_area.env_changed.connect(
		func(env:String):
			_current_env = env
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
			_helpbar_label.text = "[b][color=green][Hint][/color][/b] Use [b]up/down[/b] to navigate through submit histories!"

	)
	_hints.hint_button_clicked.connect(
		func(i:int):
			_set_hint_idx(i)
	)
	_window.hide()
	_window.draggable = draggable_window
	_window.resizable = resizable_window
	_window.visibility_changed.connect(
		func():
			console_window_visibility_changed.emit(_window.visible)
			if pause_when_active:
				get_tree().paused = _window.visible
	)
	console_window_visibility_changed.connect(_glow.set_visible)
	_helpbar.hide()
	_hints.hide()

	#check the action key
	#the open console action can be change in the export options of panku.tscn
	assert(InputMap.has_action(toggle_console_action), "Please specify an action to open the console!")

	#load widgets plan last time
	await get_tree().create_timer(1.0).timeout
	load_widgets_plan(_config["widgets_system"]["current_plan"])

func _notification(what):
	#quit event
	if what == 1006:
		#save back config
		save_current_widgets_as(_config["widgets_system"]["current_plan"])
		PankuConfig.set_config(_config)
