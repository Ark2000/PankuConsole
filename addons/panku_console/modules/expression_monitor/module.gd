class_name PankuModuleExpressionMonitor extends PankuModule

var monitor
var monitor_window:PankuLynxWindow

func init_module():
	init_monitor_window()
	load_window_data(monitor_window)

func quit_module():
	save_module_data("exprs", monitor.get_data())
	save_window_data(monitor_window)

func init_monitor_window():
	monitor = preload("./expression_monitor.tscn").instantiate()
	monitor._module = self
	monitor.set_data(load_module_data("exprs", []))
	monitor_window = core.windows_manager.create_window(monitor)
	monitor_window.queue_free_on_close = false
	monitor_window.set_window_title_text("Expression Monitor")

func open_window():
	monitor_window.show_window()
