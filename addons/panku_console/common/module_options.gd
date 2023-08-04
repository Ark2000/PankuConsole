class_name ModuleOptions extends Resource

var _module:PankuModule

var _loaded := false

func update_setting(key: String, value: Variant):
	self.set(key, value)
	if _loaded and _module:
		_module.save_module_data(key, value)
