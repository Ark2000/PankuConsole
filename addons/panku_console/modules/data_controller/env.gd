var _module:PankuModule

const _HELP_add_data_controller_window = "xxx"
func add_data_controller_window(obj:Object):
	if obj != null and is_instance_valid(obj):
		_module.add_data_controller_window([obj])
