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
	general_settings.console = core
