class_name PankuModuleNativeLogger extends PankuModule

var output_overlay:RichTextLabel
var native_logs_monitor:Node
var window:PankuLynxWindow
var logger_ui:Node

func init_module():
	# add godot log monitor
	native_logs_monitor = preload("./godot_log_monitor.gd").new()
	core.add_child(native_logs_monitor)

	# add output overlay
	output_overlay = preload("./log_overlay.tscn").instantiate()
	output_overlay._module = self
	output_overlay.clear()
	core.add_child(output_overlay)

	# add logger window
	logger_ui = preload("./logger_view.tscn").instantiate()
	logger_ui.console = core

	window = core.windows_manager.create_window(logger_ui)
	window.queue_free_on_close = false
	window.set_window_title_text("Native Logger")

	native_logs_monitor.error_msg_received.connect(
		func(msg:String):
			logger_ui.add_log(msg, 3)
	)
	native_logs_monitor.warning_msg_received.connect(
		func(msg:String):
			logger_ui.add_log(msg, 2)
	)
	native_logs_monitor.info_msg_received.connect(
		func(msg:String):
			logger_ui.add_log(msg, 1)
	)
	logger_ui.content_updated.connect(
		func(bbcode:String):
			output_overlay.text = bbcode
	)
	
	# load data
	load_window_data(window)
	get_module_opt().font_size = load_module_data("font_size", 14)
	get_module_opt().screen_overlay = load_module_data("screen_overlay", true)
	get_module_opt().screen_overlay_alpha = load_module_data("screen_overlay_alpha", 0.3)
	get_module_opt().screen_overlay_font_size = load_module_data("screen_overlay_font_size", 13)
	get_module_opt().screen_overlay_font_shadow = load_module_data("screen_overlay_font_shadow", false)
	get_module_opt().font_size = load_module_data("font_size", 14)
	logger_ui.load_data(load_module_data("logger_tags", ["[error]", "warning"]))


func quit_module():
	super.quit_module()
	save_window_data(window)
	save_module_data("screen_overlay_font_shadow", get_module_opt().screen_overlay_font_shadow)
	save_module_data("logger_tags", logger_ui.get_data())

func open_window():
	window.show_window()

func toggle_overlay():
	output_overlay.visible = not output_overlay.visible
