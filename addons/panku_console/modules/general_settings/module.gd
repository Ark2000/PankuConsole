class_name PankuModuleGeneralSettings extends PankuModule
func get_module_name(): return "GeneralSettings"

var general_settings:Resource

func open_settings_window():
	# create a new exporter window
	core.create_data_controller_window.call(general_settings)

func init_module():
	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.register_env("general_settings", env)

	general_settings = preload("./general_settings.gd").new()
	general_settings._module = self

	# load settings
	general_settings.blur_effect = load_module_data("lynx_window_blur_effect", true)
	general_settings.base_color = load_module_data("lynx_window_base_color", Color(0, 0, 0, 0.5))
	general_settings.init_expression = load_module_data("init_expr", "")

	# execute init_expr
	if general_settings.init_expression != "":
		core.execute(general_settings.init_expression)


func quit_module():
	# save settings
	save_module_data("lynx_window_blur_effect", general_settings.blur_effect)
	save_module_data("lynx_window_base_color", general_settings.base_color)
	save_module_data("init_expr", general_settings.init_expression)
