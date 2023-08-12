class_name PankuConsole extends CanvasLayer
# `console.gd` is a global singleton that provides all modules with a common interface
# you can also use some of its members to interact with the console
 
signal interactive_shell_visibility_changed(visible:bool)
signal new_expression_entered(expression:String, result)
signal new_notification_created(bbcode:String)
signal toggle_console_action_just_pressed()

const SingletonName = "Panku"
const SingletonPath = "/root/" + SingletonName
const ToggleConsoleAction = "toggle_console"

# create_data_controller(objs:Array[Object]) -> PankuLynxWindow
var create_data_controller_window:Callable = func(objs:Array): return null

var windows_manager:PankuLynxWindowsManager
var module_manager:PankuModuleManager = PankuModuleManager.new()
var gd_exprenv:PankuGDExprEnv = PankuGDExprEnv.new()

# generate a notification, the notification may be displayed in the console or in the game depending on the module's implementation
func notify(any) -> void:
	var text = str(any)
	new_notification_created.emit(text)

func _input(event: InputEvent):
	if event.is_action_pressed(ToggleConsoleAction):
		toggle_console_action_just_pressed.emit()

func _ready():
	assert(get_tree().current_scene != self, "Do not run console.tscn as a scene!")

	windows_manager = $LynxWindowsManager
	var base_instance = preload("./common/repl_base_instance.gd").new()
	base_instance._core = self
	gd_exprenv.set_base_instance(base_instance)

	# add default input action if not defined by user
	if not InputMap.has_action(ToggleConsoleAction):
		InputMap.add_action(ToggleConsoleAction)
		var default_toggle_console_event = InputEventKey.new()
		default_toggle_console_event.physical_keycode = KEY_QUOTELEFT
		InputMap.action_add_event(ToggleConsoleAction, default_toggle_console_event)

	# since panku console servers numerous purposes
	# we use a module system to manage all different features
	# modules are invisible to each other by design to avoid coupling
	# you can add or remove any modules here as you wish
	var modules:Array[PankuModule] = [
		PankuModuleNativeLogger.new(),
		PankuModuleScreenNotifier.new(),
		PankuModuleSystemReport.new(),
		PankuModuleHistoryManager.new(),
		PankuModuleEngineTools.new(),
		PankuModuleKeyboardShortcuts.new(),
		PankuModuleCheckLatestRelease.new(),
		PankuModuleInteractiveShell.new(),
		PankuModuleGeneralSettings.new(),
		PankuModuleDataController.new(),
		PankuModuleScreenCrtEffect.new(),
		PankuModuleExpressionMonitor.new(),
		PankuModuleTextureViewer.new(),
		PankuModuleVariableTracker.new(),
	]
	module_manager.init_manager(self, modules)

func _notification(what):
	# quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		module_manager.quit_modules()
