class_name PankuModuleExpressionMonitor2 extends PankuModule

const ExpMonitorWidget = preload("res://addons/panku_console/modules/expression_monitor_2/exp_monitor.tscn")
const ExpMonitor = preload("res://addons/panku_console/modules/expression_monitor_2/exp_monitor.gd")
const ExpMonitorOverlay = preload("res://addons/panku_console/modules/expression_monitor_2/exp_monitor_overlay.tscn")

var overlay:Control
var monitors:Array[ExpMonitor] = []

func init_module():
	overlay = ExpMonitorOverlay.instantiate()
	core.add_child(overlay)

	var data:Array = load_module_data("monitors", [])
	set_data(data)

func quit_module():
	super.quit_module()
	save_module_data("monitors", get_data())

# return: Array[Dictionary]
func get_data() -> Array:
	var data = []
	for monitor_data in monitors:
		data.append(monitor_data.get_dict())
	return data

# data:Array[Dictionary]
func set_data(data:Array):
	monitors.clear()
	for monitor_dict in data:
		var monitor:ExpMonitor = ExpMonitorWidget.instantiate()
		overlay.add_child(monitor)
		monitor.load_dict(monitor_dict)
		monitors.append(monitor)

func update_module(delta:float):
	for monitor in monitors:
		monitor.remaining_time -= delta
		if monitor.remaining_time > 0: continue
		
		monitor.remaining_time = monitor.update_interval
		var eval_result_dict:Dictionary = core.gd_exprenv.execute(monitor.expression_string)
		var eval_result:String = str(eval_result_dict["result"])
		monitor.set_label_text(eval_result)
		monitor.size = monitor.get_minimum_size()
		monitor.update_position()
