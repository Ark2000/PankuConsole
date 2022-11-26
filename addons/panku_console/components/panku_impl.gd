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
@onready var _widgets = $Widgets

const _floating_widget_pck = preload("res://addons/panku_console/components/FloatingWidget/floating_widget.tscn")

var _envs = {}
var _expression = Expression.new()
var _config = PankuConfig.get_config()

func is_console_window_opened():
	return _window.visible

func register_env(env_name:String, env:Node):
	_envs[env_name] = env
	_input_area.add_option(env_name)
	notify("[color=green][Info][/color] [b]%s[/b] env loaded!"%env_name)
	env.tree_exiting.connect(
		func(): remove_env(env_name)
	)
	
func get_env(env_name:String) -> Node:
	return _envs.get(env_name)

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
	
func execute(env:String, exp:String):
	var result = _execute(env, exp)
	output("[%s] %s"%[env, exp])
	if !_failed_flag:
		output("%s"%result)
	else:
		output("[color=red]%s[/color]"%result)

var _failed_flag = false
func _execute(env:String, exp:String) -> String:
	_failed_flag = false
	var obj = _envs[env]
	var error = _expression.parse(exp)
	if error != OK:
		_failed_flag = true
		return _expression.get_error_text()
	var result = _expression.execute([], obj)
	if not _expression.has_execute_failed():
		return str(result)
	else:
		_failed_flag = true
		return "failed"

#update config when adding a widget
func add_widget(update_delay:float, env:String, update_exp:String, pressed_exp:String, position:Vector2):
	var w = _add_widget(update_delay, env, update_exp, pressed_exp, position)
	save_current_widgets_as(_config["widgets_system"]["current_plan"])
	return w

func _add_widget(update_delay:float, env:String, update_exp:String, pressed_exp:String, position:Vector2):
	var new_widget = _floating_widget_pck.instantiate()
	_widgets.add_child(new_widget)
	new_widget.update_delay = update_delay
	new_widget.get_widget_text = func(): return _execute(env, update_exp)
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
	
	return true

func save_current_widgets_as(plan:String):
	var d = []
	for w in _widgets.get_children():
		d.append(w.get_meta("info"))
	_config["widgets_system"]["plans"][plan] = d
	_config["widgets_system"]["current_plan"] = plan

func delete_widgets_plan(plan:String):
	if plan == _config["widgets_system"]["current_plan"]:
		return false
	_config["widgets_system"]["plans"].erase(plan)
	return true

func _input(_e):
	if Input.is_action_just_pressed(open_console_action):
		_input_area.input.editable = !_window.visible
		await get_tree().process_frame
		_window.visible = !_window.visible

func _process(d):
	_glow.size = _console_logs.size
	_glow.position = _console_logs.global_position

func _ready():
	assert(get_tree().current_scene != self, "Do not run this directly")

	output("[b][color=burlywood][ Panku Console ][/color][/b]")
	output("[color=burlywood][b][color=burlywood]Version 1.0.1[/color][/b][/color]")
	output("[color=burlywood][b]Check [color=green]default_env.gd[/color] or simply type [color=green]help[/color] to see what you can do now![/b][/color]")
	output("[color=burlywood][b]For more info, please visit: [color=green][url=https://github.com/Ark2000/PankuConsole]project github page[/url][/color][/b][/color]")
	output("")

	_input_area.clear_options()
	_input_area.submitted.connect(execute)
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

	#load widgets plan last time
	await get_tree().create_timer(0.5).timeout
	load_widgets_plan(_config["widgets_system"]["current_plan"])

func _notification(what):
	#quit event
	if what == 1006:
		#save back config
		save_current_widgets_as(_config["widgets_system"]["current_plan"])
		PankuConfig.set_config(_config)
