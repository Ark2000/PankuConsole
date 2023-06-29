class_name PankuModuleGeneralSettings extends PankuModule

func open_settings_window():
	# create a new exporter window
	var window:PankuLynxWindow = core.create_data_controller_window.call(core.module_manager.get_module_option_objects())
	window.set_window_title_text("General Settings")


func init_module():
	# load settings
	get_module_opt().window_blur_effect = load_module_data("lynx_window_blur_effect", true)
	get_module_opt().window_color = load_module_data("lynx_window_base_color", Color("#000c1880"))
	get_module_opt().enable_os_window = load_module_data("lynx_window_enable_os_window", false)
	get_module_opt().os_window_bg_color = load_module_data("lynx_window_os_window_bg_color", Color(0, 0, 0, 0))

func quit_module():
	# save settings
	save_module_data("lynx_window_blur_effect", get_module_opt().window_blur_effect)
	save_module_data("lynx_window_base_color", get_module_opt().window_color)
	save_module_data("lynx_window_enable_os_window", get_module_opt().enable_os_window)
	save_module_data("lynx_window_os_window_bg_color", get_module_opt().os_window_bg_color)
	
