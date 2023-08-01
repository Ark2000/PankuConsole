class_name ModuleOptions extends Resource

var _module:PankuModule

signal update_setting(key: String, value: Variant)

var loaded := false:
	set(l):
		if l:
			update_setting.connect(_module.save_module_data)
		else:
			if update_setting.is_connected(_module.save_module_data):
				update_setting.disconnect(_module.save_module_data)
	get:
		return update_setting.is_connected(_module.save_module_data)

