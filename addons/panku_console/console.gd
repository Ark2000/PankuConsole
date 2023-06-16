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

@export var windows_manager:Node

var module_manager:PankuModuleManager = PankuModuleManager.new()
var gd_exprenv:PankuGDExprEnv = PankuGDExprEnv.new()

## Generate a notification
func notify(any) -> void:
	var text = str(any)
	new_notification_created.emit(text)

func _input(_e):
	if Input.is_action_just_pressed(toggle_console_action):
		toggle_console_action_just_pressed.emit()

func _ready():
	assert(get_tree().current_scene != self, "Do not run console.tscn as a scene!")

	var base_instance = preload("./core/repl_base_instance.gd").new()
	base_instance._core = self
	gd_exprenv.set_base_instance(base_instance)

	toggle_console_action = ProjectSettings.get("panku/toggle_console_action")

	#check the action key
	#the open console action can be change in the export options of panku.tscn
	assert(InputMap.has_action(toggle_console_action), "Please specify an action to open the console!")

	var modules:Array[PankuModule] = [
		PankuModuleSceneRootTracker.new(),
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
