class_name PankuModuleDataController extends PankuModule

const exporter_prefab = preload("./exporter/exporter_2.tscn")

func init_module():
	core.create_data_controller_window = add_data_controller_window
	core.new_expression_entered.connect(
		func(exp:String, result):
			if !result["failed"] and result["result"] is Object:
				var window = add_data_controller_window([result["result"]])
				window.set_window_title_text(exp)
				if window.get_content().is_empty():
					window.queue_free()
	)

func add_data_controller_window(objs:Array) -> PankuLynxWindow:
	var data_controller = exporter_prefab.instantiate()
	data_controller.objects = objs
	var new_window:PankuLynxWindow = core.windows_manager.create_window(data_controller)
	new_window.centered()
	new_window.move_to_front()
	return new_window
