extends "res://addons/panku_console/default_repl_envs/repl_env.gd"

const _HELP_cls = "Clear interactive shell's output"
var cls:
	get:
		get_tree().create_timer(0.1, true, false, true).timeout.connect(
			Console._full_repl.get_content().clear_output
		)

const _HELP_notify = "Generate a notification"
func notify(any):
	Console.notify(any)

const _HELP_check_update = "Fetch latest release information from Github"
var check_update:
	get: return Console._full_repl.get_content().check_latest_release()

const _HELP_open_settings = "Open settings window"
var open_settings:
	get: return Console.add_exporter_window(Console.options, "Settings")

const _HELP_open_keybindings = "Open expression key bindings window"
var open_keybindings:
	get: return Console.open_expression_key_mapper()

const _HELP_open_history = "Open expression history window"
var open_history:
	get: return Console.open_expression_history()
	
const _HELP_open_logger = "Open logger window"
var open_logger:
	get: return Console.open_logger()

const _HELP_toggle_logger_overlay = "Toggle visibility of logger overlay"
var toggle_logger_overlay:
	get:
		Console.output_overlay.visible = !Console.output_overlay.visible
		return Console.output_overlay.visible

const _HELP_add_exp_monitor = "Add an expression monitor"
func add_exp_monitor(expression:String):
	var window = Console.add_monitor_window(expression, 0.1)
	window.centered()
	window.move_to_front()
	return window

const _HELP_add_exp_button = "Add an expression button"
func add_exp_button(expression:String, _display_name:String):
	var window = Console.add_monitor_window(expression, 999999)
	window.centered()
	window.move_to_front()
	return window

const _HELP_monitor_user_obj = "Show all public script properties of a user object."
func monitor_user_obj(obj:Object):
	return PankuConsole.Utils.get_object_outline(obj)

const _HELP_add_profiler = "Add a simple profiler"
var add_profiler:
	get: return Console.add_monitor_window("engine.performance_info", 0.2)

const _HELP_add_exporter = "Add a window to show and modify export properties"
func add_exporter(obj_exp:String):
	return Console.add_exporter_window_by_expression(obj_exp)

const _HELP_toggle_crt_effect = "The good old days"
func toggle_crt_effect():
	Console.effect_crt.visible = !Console.effect_crt.visible
