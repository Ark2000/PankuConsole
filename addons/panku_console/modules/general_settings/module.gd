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

# Taken from https://github.com/godotengine/godot/blob/master/editor/editor_settings.cpp#L1539
static func get_auto_display_scale() -> float:
	var flag := false
	match OS.get_name():
		"macOS":
			flag = true
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			if DisplayServer.get_name() == "Wayland":
				flag = true
		"Android":
			flag = true
		"iOS":
			flag = true
	if flag:
		return DisplayServer.screen_get_max_scale()
		
	var screen := DisplayServer.window_get_current_screen()
	
	if (DisplayServer.screen_get_size(screen) == Vector2i()):
		# Invalid screen size, skip.
		return 1.0
	
	# Use the smallest dimension to use a correct display scale on portrait displays.
	var smallest_dimension = min(DisplayServer.screen_get_size().x, DisplayServer.screen_get_size().y)
	if DisplayServer.screen_get_dpi(screen) >= 192 and smallest_dimension >= 1400:
		# hiDPI display.
		return 2.0
	elif smallest_dimension >= 1700:
		# Likely a hiDPI display, but we aren't certain due to the returned DPI.
		# Use an intermediate scale to handle this situation.
		return 1.5
	elif smallest_dimension <= 800:
		# Small loDPI display. Use a smaller display scale so that editor elements fit more easily.
		# Icons won't look great, but this is better than having editor elements overflow from its window.
		return 0.75
	return 1.0

func init_module():
	# load settings
	get_module_opt().window_blur_effect = load_module_data("window_blur_effect", true)
	get_module_opt().window_base_color = load_module_data("window_base_color", Color("#000c1880"))
	get_module_opt().enable_os_window = load_module_data("enable_os_window", false)
	get_module_opt().os_window_bg_color = load_module_data("os_window_bg_color", Color(0, 0, 0, 0))
	get_module_opt().global_font_size = load_module_data("global_font_size", int(16 * get_auto_display_scale()))

func quit_module():
	super.quit_module()
	if window:
		save_window_data(window)
