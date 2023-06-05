class_name PankuModuleInteractiveShell extends PankuModule
func get_module_name(): return "InteractiveShell"

var window:PankuLynxWindow
var interactive_shell:Node

func init_module():
	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.register_env("interactive_shell", env)

	interactive_shell = preload("./console_ui/panku_console_ui.tscn").instantiate()
	window = core.create_window(interactive_shell)
	window.queue_free_on_close = false
	window.set_caption("Interative Shell V2")
	window.hide_options_button()
	load_window_data(window)

	interactive_shell.output("hello!")

func quit_module():
	save_window_data(window)