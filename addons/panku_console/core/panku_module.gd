class_name PankuModule

var core:PankuConsole

# a unique name for the module
func get_module_name():
	assert(false, "get_module_name not implemented")

# called when the module is loaded
func init_module():
	assert(false, "init_module not implemented")

# called when the module is unloaded (quit program)
func quit_module():
	pass

# called at the start of each physics frame
func update_module(delta:float):
	pass

func save_module_data(key:String, value:Variant):
	var cfg:Dictionary = core.Config.get_config()
	var module_name:String = get_module_name()
	if !cfg.has(module_name):
		cfg[module_name] = {}
	cfg[module_name][key] = value
	core.Config.set_config(cfg)

func load_module_data(key:String, default_value:Variant = null) -> Variant:
	var cfg:Dictionary = core.Config.get_config()
	var module_name:String = get_module_name()
	var module_data = cfg.get(module_name, {})
	return module_data.get(key, default_value)

func has_module_data(key:String) -> bool:
	var cfg:Dictionary = core.Config.get_config()
	var module_name:String = get_module_name()
	var module_data = cfg.get(module_name, {})
	return module_data.has(key)

func load_window_data(window:PankuLynxWindow):
	window.position = load_module_data("window_position", window.get_centered_position())
	window.size = load_module_data("window_size", window.size)
	window.visible = load_module_data("window_visibility", false)

func save_window_data(window:PankuLynxWindow):
	save_module_data("window_position", window.position)
	save_module_data("window_size", window.size)
	save_module_data("window_visibility", window.visible)
