class_name PankuModuleGeneralSettings extends PankuModule

var window:PankuLynxWindow

func open_settings_window():
	if window: return
	# create a new exporter window
	window = core.create_data_controller_window.call(
		core.module_manager.get_module_option_objects()
	)
	window.set_window_title_text("General Settings")
	load_window_data(window)
	window.show_window()
	window.window_closed.connect(
		func():
			save_window_data(window)
			window = null
	)

# See https://github.com/MewPurPur/GodSVG/blob/main/src/HandlerGUI.gd
static func calculate_auto_scale() -> int:
	var screen := DisplayServer.window_get_current_screen()
	if DisplayServer.screen_get_size(screen) == Vector2i():
		return 1.0
	# Use the smallest dimension to use a correct display scale on portrait displays.
	var smallest_dimension := mini(
		DisplayServer.screen_get_size(screen).x,
		DisplayServer.screen_get_size(screen).y
	)
	
	var dpi :=  DisplayServer.screen_get_dpi(screen)
	if dpi != 72:
		if dpi < 72: 		return 0.75
		elif dpi <= 96: 	return 1.0
		elif dpi <= 120:	return 1.25
		elif dpi <= 160:	return 1.5
		elif dpi <= 200:	return 2.0
		elif dpi <= 240:	return 2.5
		elif dpi <= 320:	return 3.0
		elif dpi <= 480:	return 4.0
		else:  				return 5.0
	elif smallest_dimension >= 1700:
		# Likely a hiDPI display, but we aren't certain due to the returned DPI.
		# Use an intermediate scale to handle this situation.
		return 1.5
	return 1.0

func init_module():
	# load settings
	get_module_opt().window_blur_effect = load_module_data("window_blur_effect", true)
	get_module_opt().window_base_color = load_module_data("window_base_color", Color("#000c1880"))
	get_module_opt().enable_os_window = load_module_data("enable_os_window", false)
	get_module_opt().os_window_bg_color = load_module_data("os_window_bg_color", Color(0, 0, 0, 0))
	get_module_opt().global_font_size = load_module_data("global_font_size", int(16 * calculate_auto_scale()))

func quit_module():
	super.quit_module()
	if window:
		save_window_data(window)
