class_name PankuModuleDataController extends PankuModule
func get_module_name(): return "DataController"

const exporter_prefab = preload("./exporter/exporter_2.tscn")

func init_module():
	core.create_data_controller_window = add_data_controller_window

func add_data_controller_window(obj:Object) -> PankuLynxWindow:
	if !obj.get_script():
		return null
	var data_controller = exporter_prefab.instantiate()
	var new_window:PankuLynxWindow = core.create_window(data_controller)
	data_controller.setup(obj)
	new_window._options_btn.hide()
	new_window.centered()
	new_window.move_to_front()
	return new_window
