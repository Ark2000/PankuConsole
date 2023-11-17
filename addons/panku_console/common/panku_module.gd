class_name PankuModule

var core:PankuConsole

var _env:RefCounted = null
var _opt:ModuleOptions = null

# dir name of the module
func get_module_name() -> String:
	return get_script().resource_path.get_base_dir().get_file()

# called when the module is loaded
func init_module():
	pass

# called when the module is unloaded (quit program)
func quit_module():
	if _opt:
		_opt._loaded = false

# called at the start of each physics frame
func update_module(delta:float):
	pass

func save_module_data(key:String, value:Variant):
	var cfg:Dictionary = PankuConfig.get_config()
	var module_name:String = get_module_name()
	if !cfg.has(module_name):
		cfg[module_name] = {}
	cfg[module_name][key] = value
	PankuConfig.set_config(cfg)

func load_module_data(key:String, default_value:Variant = null) -> Variant:
	var cfg:Dictionary = PankuConfig.get_config()
	var module_name:String = get_module_name()
	var module_data = cfg.get(module_name, {})
	return module_data.get(key, default_value)

func has_module_data(key:String) -> bool:
	var cfg:Dictionary = PankuConfig.get_config()
	var module_name:String = get_module_name()
	var module_data = cfg.get(module_name, {})
	return module_data.has(key)

func load_window_data(window:PankuLynxWindow):
	window.position = load_module_data("window_position", window.get_layout_position([
		Control.PRESET_TOP_LEFT,
		Control.PRESET_CENTER_TOP,
		Control.PRESET_TOP_RIGHT,
		Control.PRESET_CENTER_LEFT,
		Control.PRESET_CENTER,
		Control.PRESET_CENTER_RIGHT,
		Control.PRESET_BOTTOM_LEFT,
		Control.PRESET_CENTER_BOTTOM,
		Control.PRESET_BOTTOM_RIGHT,
	][randi()%9]))
	window.size = load_module_data("window_size", window.get_normal_window_size())
	window.set_window_visibility(load_module_data("window_visibility", false))

func save_window_data(window:PankuLynxWindow):
	save_module_data("window_position", window.position)
	save_module_data("window_size", window.get_normal_window_size())
	save_module_data("window_visibility", window.visible)

func get_module_env() -> RefCounted:
	return _env

func get_module_opt() -> ModuleOptions:
	return _opt

func _init_module():
	var module_script_dir:String = get_script().resource_path.get_base_dir()
	var env_script_path = module_script_dir + "/env.gd"
	var opt_script_path = module_script_dir + "/opt.gd"
	
	if FileAccess.file_exists(env_script_path):
		_env = load(env_script_path).new()
		_env._module = self
		core.gd_exprenv.register_env(get_module_name(), _env)

	if FileAccess.file_exists(opt_script_path):
		#print(opt_script_path)
		_opt = load(opt_script_path).new() as ModuleOptions
		_opt._module = self

	init_module()
	if _opt:
		_opt._loaded = true
