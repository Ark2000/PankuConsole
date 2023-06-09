class_name PankuModuleNativeLogger extends PankuModule
func get_module_name(): return "NativeLogger"

var logger_options:Resource
var output_overlay:RichTextLabel
var native_logs_monitor:Node
var window:PankuLynxWindow
var logger_ui:Node

func init_module():
	# print("init_module:", self.get_module_name())

	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.register_env("native_logger", env)

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

	logger_options = preload("./logger_options.gd").new()
	logger_options._module = self

	window = core.create_window(logger_ui)
	window.queue_free_on_close = false
	window._options_btn.pressed.connect(
		func():
			var data_controller:PankuLynxWindow = core.create_data_controller_window.call(logger_options)
			if data_controller:
				data_controller.set_caption("Logger Settings")
	)
	window.set_caption("Native Logger")
	load_window_data(window)

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

	# setup window
	# window.get_content().set_meta("content_type", "logger")

	output_overlay.load_data(load_module_data("logger_overlay", {}))
	logger_ui.load_data(load_module_data("logger", {}))


func quit_module():
	save_module_data("logger_overlay", output_overlay.get_data())
	save_module_data("logger", logger_ui.get_data())
	save_window_data(window)
