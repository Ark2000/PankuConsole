class_name PankuModuleKeyboardShortcuts extends PankuModule
func get_module_name(): return "KeyboardShortcuts"

var window:PankuLynxWindow
var key_mapper

func init_module():

	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.register_env("keyboard_shortcuts", env)

	# setup ui
	key_mapper = preload("./exp_key_mapper_2.tscn").instantiate()
	key_mapper.console = core

	# bind window
	window = core.create_window(key_mapper)
	window.queue_free_on_close = false
	window.set_caption("Keyboard Shortcuts")
	window.hide_options_button()

	load_window_data(window)
	key_mapper.load_data(load_module_data("key_mapper", []))

func quit_module():
	save_window_data(window)
	save_module_data("key_mapper", key_mapper.get_data())
