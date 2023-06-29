class_name PankuModuleExpressionMonitor extends PankuModule

var monitor
var monitor_window:PankuLynxWindow

func init_module():
	init_monitor_window()
	load_window_data(monitor_window)
	monitor.monitor_groups_ui.load_persistent_data(load_module_data("monitor_data", [{
		"group_name": "default group",
		"expressions": []
	}]))

func quit_module():
	save_window_data(monitor_window)
	save_module_data("monitor_data", monitor.monitor_groups_ui.get_persistent_data())

func init_monitor_window():
	monitor = preload("./expression_monitor2.tscn").instantiate()
	monitor._module = self
#	monitor.set_data(load_module_data("exprs", []))
	monitor_window = core.windows_manager.create_window(monitor)
	monitor_window.queue_free_on_close = false
	monitor_window.set_window_title_text("Expression Monitor")

func open_window():
	monitor_window.show_window()
