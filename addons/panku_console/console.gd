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

## The input action used to toggle console. By default it is KEY_QUOTELEFT.
var toggle_console_action:String

## If [code]true[/code], pause the game when the console window is active.
# var pause_when_active:bool:
# 	set(v):
# 		pause_when_active = v
# 		is_repl_window_opened = is_repl_window_opened

@export var windows_manager:Node

# The current scene root node, which will be updated automatically when the scene changes.
var _current_scene_root:Node

var module_manager:PankuModuleManager = PankuModuleManager.new()
var gd_exprenv:PankuGDExprEnv = PankuGDExprEnv.new()

## Generate a notification
func notify(any) -> void:
	var text = str(any)
	new_notification_created.emit(text)

func create_window(content:Control):
	var new_window:PankuLynxWindow = preload("./core/lynx_window2/lynx_window_2.tscn").instantiate()
	content.anchors_preset = Control.PRESET_FULL_RECT
	new_window.set_content(content)
	windows_manager.add_child(new_window)
	return new_window

func _input(_e):
	if Input.is_action_just_pressed(toggle_console_action):
		# is_repl_window_opened = !is_repl_window_opened
		toggle_console_action_just_pressed.emit()

func _ready():
	assert(get_tree().current_scene != self, "Do not run console.tscn as a scene!")

	var base_instance = preload("./core/repl_base_instance.gd").new()
	base_instance.core = self
	gd_exprenv.set_base_instance(base_instance)

	toggle_console_action = ProjectSettings.get("panku/toggle_console_action")

	#check the action key
	#the open console action can be change in the export options of panku.tscn
	assert(InputMap.has_action(toggle_console_action), "Please specify an action to open the console!")

	setup_scene_root_tracker()

	var modules:Array[PankuModule] = [
		PankuModuleScreenNotifier.new(),
		PankuModuleSystemReport.new(),
		PankuModuleHistoryManager.new(),
		PankuModuleEngineTools.new(),
		PankuModuleKeyboardShortcuts.new(),
		PankuModuleCheckLatestRelease.new(),
		PankuModuleNativeLogger.new(),
		PankuModuleInteractiveShell.new(),
		PankuModuleGeneralSettings.new(),
		PankuModuleDataController.new(),
		PankuModuleScreenCrtEffect.new(),
		PankuModuleExpressionMonitor.new(),
	]
	module_manager.init_manager(self, modules)

func _notification(what):
	#quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		module_manager.quit_modules()

# always register the current scene root as `current`
func setup_scene_root_tracker():
	_current_scene_root = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	gd_exprenv.register_env("current", _current_scene_root)
	create_tween().set_loops().tween_callback(
		func(): 
			var r = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
			if r != _current_scene_root:
				_current_scene_root = r
				gd_exprenv.register_env("current", _current_scene_root)
	).set_delay(0.1)
