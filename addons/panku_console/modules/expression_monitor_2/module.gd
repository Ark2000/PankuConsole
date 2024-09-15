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

func update_module(delta:float):
	# if further optimization is needed, we can use priority queue
	for monitor in monitors: monitor.update_monitor(delta)

func add_monitor(data = null):
	var monitor:ExpMonitor = ExpMonitorWidget.instantiate()
	overlay.add_child(monitor)
	monitor.set_eval_env(core.gd_exprenv)
	if data: monitor.load(data)
	monitors.append(monitor)

# return: Array[Dictionary]
func get_data() -> Array:
	var data = []
	for monitor_data in monitors:
		data.append(monitor_data.save())
	return data

# data:Array[Dictionary]
func set_data(data:Array):
	monitors.clear()
	for monitor_dict in data: add_monitor(monitor_dict)

func test_add():
	add_monitor()

func test_get(i):
	return monitors[i]
