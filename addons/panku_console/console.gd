class_name PankuConsole extends CanvasLayer

## Emitted when the visibility (hidden/visible) of console window changes.
signal repl_visible_about_to_change(is_visible:bool)
signal repl_visible_changed(is_visible:bool)

signal new_expression_entered(expression:String)
signal new_notification_created(bbcode:String)

signal check_lasted_release_requested()
signal check_lasted_release_responded(msg:Dictionary)

signal toggle_console_action_just_pressed()

# create_data_controller(obj:Object) -> PankuLynxWindow
# this function should be implemented by related module.
var create_data_controller_window:Callable = func(obj:Object): return null

# Global singleton name is buggy in Godot 4.0, so we get the singleton by path instead.
const SingletonName = "Console"
const SingletonPath = "/root/" + SingletonName

#Static helper classes
const Config = preload("res://addons/panku_console/core/config.gd")
const Utils = preload("res://addons/panku_console/core/utils.gd")

## The input action used to toggle console. By default it is KEY_QUOTELEFT.
var toggle_console_action:String

## If [code]true[/code], pause the game when the console window is active.
# var pause_when_active:bool:
# 	set(v):
# 		pause_when_active = v
# 		is_repl_window_opened = is_repl_window_opened

var _base_instance:Object
@export var w_manager:Node

var _envs = {}
var _envs_info = {}
var _expression = Expression.new()

# The current scene root node, which will be updated automatically when the scene changes.
var _current_scene_root:Node

## Register an environment that run expressions.
## [br][code]env_name[/code]: the name of the environment
## [br][code]env[/code]: The base instance that runs the expressions. For exmaple your player node.
func register_env(env_name:String, env:Object):
	_envs[env_name] = env
#	output("[color=green][Info][/color] [b]%s[/b] env loaded!"%env_name)
	if env is Node:
		env.tree_exiting.connect(
			func(): remove_env(env_name)
		)
	if env.get_script():
		var env_info = Utils.extract_info_from_script(env.get_script())
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

## Generate a notification
func notify(any) -> void:
	var text = str(any)
	new_notification_created.emit(text)

#Execute an expression in a preset environment.
func execute(exp:String) -> Dictionary:
	return Utils.execute_exp(exp, _expression, _base_instance, _envs)

func get_available_export_objs() -> Array:
	var result = []
	for obj_name in _envs:
		var obj = _envs[obj_name]
		if !obj.get_script():
			continue
		var export_properties = Utils.get_export_properties_from_script(obj.get_script())
		if export_properties.is_empty():
			continue
		result.push_back(obj_name)
	return result

func create_window(content:Control):
	var new_window:PankuLynxWindow = preload("./core/lynx_window2/lynx_window_2.tscn").instantiate()
	content.anchors_preset = Control.PRESET_FULL_RECT
	new_window.set_content(content)
	w_manager.add_child(new_window)
	return new_window

func _input(_e):
	if Input.is_action_just_pressed(toggle_console_action):
		# is_repl_window_opened = !is_repl_window_opened
		toggle_console_action_just_pressed.emit()

func _ready():
	assert(get_tree().current_scene != self, "Do not run this directly")

	_base_instance = preload("./core/repl_base_instance.gd").new()
	_base_instance.core = self

	toggle_console_action = ProjectSettings.get("panku/toggle_console_action")

	#check the action key
	#the open console action can be change in the export options of panku.tscn
	assert(InputMap.has_action(toggle_console_action), "Please specify an action to open the console!")

	#add info of base instance
	var env_info = Utils.extract_info_from_script(_base_instance.get_script())
	for k in env_info: _envs_info[k] = env_info[k]

	setup_scene_root_tracker()

	load_modules()

func _notification(what):
	#quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit_modules()

# always register the current scene root as `current`
func setup_scene_root_tracker():
	_current_scene_root = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	register_env("current", _current_scene_root)
	create_tween().set_loops().tween_callback(
		func(): 
			var r = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
			if r != _current_scene_root:
				_current_scene_root = r
				register_env("current", _current_scene_root)
	).set_delay(0.1)

var _modules:Array[PankuModule]
var _modules_table:Dictionary

func load_modules():

	_modules.append(preload("./modules/screen_notifier/module.gd").new())
	_modules.append(preload("./modules/system_report/module.gd").new())
	_modules.append(preload("./modules/history_manager/module.gd").new())
	_modules.append(preload("./modules/engine_tools/module.gd").new())
	_modules.append(preload("./modules/keyboard_shortcuts/module.gd").new())
	_modules.append(preload("./modules/check_latest_release/module.gd").new())
	_modules.append(preload("./modules/native_logger/module.gd").new())
	_modules.append(preload("./modules/interactive_shell/module.gd").new())
	_modules.append(preload("./modules/general_settings/module.gd").new())
	_modules.append(preload("./modules/data_controller/module.gd").new())
	_modules.append(preload("./modules/screen_crt_effect/module.gd").new())
	_modules.append(preload("./modules/expression_monitor/module.gd").new())

	for _m in _modules:
		var module:PankuModule = _m
		_modules_table[module.get_module_name()] = module

	for _m in _modules:
		var module:PankuModule = _m
		module.core = self
		module.init_module()

	print("modules: ", _modules_table)

func update_modules(delta:float):
	for _m in _modules:
		var module:PankuModule = _m
		module.update_module(delta)

func get_module(module_name:String):
	return _modules_table[module_name]

func has_module(module_name:String):
	return _modules_table.has(module_name)

func quit_modules():
	for _m in _modules:
		var module:PankuModule = _m
		module.quit_module()
