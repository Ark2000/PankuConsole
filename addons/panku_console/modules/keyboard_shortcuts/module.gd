class_name PankuModuleKeyboardShortcuts extends PankuModule
func get_module_name(): return "KeyboardShortcuts"

var window:PankuLynxWindow

func init_module():

	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.register_env("keyboard_shortcuts", env)

	# setup ui
	var ui := preload("./exp_key_mapper_2.tscn").instantiate()
	ui.console = core

	# bind window
	window = core.create_window(ui)
	window.queue_free_on_close = false
	window.set_caption("Keyboard Shortcuts")
	window.hide_options_button()
	window.hide()
