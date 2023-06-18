class_name PankuModuleKeyboardShortcuts extends PankuModule

var window:PankuLynxWindow
var key_mapper

func init_module():
	# setup ui
	key_mapper = preload("./exp_key_mapper_2.tscn").instantiate()
	key_mapper.console = core

	# bind window
	window = core.windows_manager.create_window(key_mapper)
	window.queue_free_on_close = false
	window.set_window_title_text("Keyboard Shortcuts")

	load_window_data(window)
	key_mapper.load_data(load_module_data("key_mapper", []))

func quit_module():
	save_window_data(window)
	save_module_data("key_mapper", key_mapper.get_data())

func open_window():
	window.show_window()
