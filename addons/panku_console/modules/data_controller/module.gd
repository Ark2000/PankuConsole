class_name PankuModuleDataController extends PankuModule
func get_module_name(): return "DataController"

const exporter_prefab = preload("./exporter/exporter_2.tscn")

func init_module():
	core.create_data_controller_window = add_data_controller_window

func add_data_controller_window(objs:Array) -> PankuLynxWindow:
	print(objs)
	var data_controller = exporter_prefab.instantiate()
	data_controller.objects = objs
	var new_window:PankuLynxWindow = core.windows_manager.create_window(data_controller)
	new_window.centered()
	new_window.move_to_front()
	return new_window
