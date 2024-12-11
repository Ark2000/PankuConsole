class_name PankuModule extends Node
# extends Node: A hacky way to avoid cyclic RefCounted verbose warnings which is uncessary to worry about.

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

func _get_module_key(key:String) -> String:
	return ".".join([get_module_name(), key])

func save_module_data(key:String, value:Variant):
	PankuConfig.set_value(_get_module_key(key), value)

func load_module_data(key:String, default_value:Variant = null) -> Variant:
	return PankuConfig.get_value(_get_module_key(key), default_value)

func has_module_data(key:String) -> bool:
	return PankuConfig.get_value(_get_module_key(key)) == null

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
	_save_window_geometry(window)
	save_module_data("window_visibility", window.visible)


func _save_window_geometry(window:PankuLynxWindow):
	save_module_data("window_position", window.position)
	save_module_data("window_size", window.get_normal_window_size())


# Add hook to window to auto save its geometry on close.
func add_auto_save_hook(window: PankuLynxWindow) -> void:
	# Here some global settings check can be implemented,
	# if we decide to make "save on close" feature optional
	window.window_closed.connect(_save_window_geometry.bind(window))


func get_module_env() -> RefCounted:
	return _env

func get_module_opt() -> ModuleOptions:
	return _opt

func _init_module():
	var module_script_dir:String = get_script().resource_path.get_base_dir()
	var env_script_path = module_script_dir + "/env.gd"
	var opt_script_path = module_script_dir + "/opt.gd"

	if ResourceLoader.exists(env_script_path, "GDScript"):
		_env = load(env_script_path).new()
		_env._module = self
		core.gd_exprenv.register_env(get_module_name(), _env)

	if ResourceLoader.exists(opt_script_path, "GDScript"):
		#print(opt_script_path)
		_opt = load(opt_script_path).new() as ModuleOptions
		_opt._module = self

	init_module()
	if _opt:
		_opt._loaded = true
