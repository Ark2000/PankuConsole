class_name PankuModuleManager

var _modules:Array[PankuModule]
var _modules_table:Dictionary
var _core:PankuConsole

func init_manager(_core:PankuConsole, _modules:Array[PankuModule]):
	self._modules = _modules
	self._core = _core
	load_modules()

func load_modules():

	# The extra tree structure is purely used for avoiding using RefCounted which may cause uncessary leaked instance warnings.
	var manager_node:Node = Node.new()
	manager_node.name = "_Modules_"
	_core.add_child(manager_node)

	for _m in _modules:
		var module:PankuModule = _m
		_modules_table[module.get_module_name()] = module

		module.name = module.get_module_name()
		manager_node.add_child(module)

	for _m in _modules:
		var module:PankuModule = _m
		module.core = _core
		module._init_module()
		#print("[info] %s module loaded!" % module.get_module_name())

func update_modules(delta:float):
	for _m in _modules:
		var module:PankuModule = _m
		module.update_module(delta)

func get_module(module_name:String):
	return _modules_table[module_name]

func has_module(module_name:String):
	return _modules_table.has(module_name)

func get_module_option_objects():
	var objects = []
	for _m in _modules:
		var module:PankuModule = _m
		if module._opt != null:
			objects.append(module._opt)
	return objects

func quit_modules():
	for _m in _modules:
		var module:PankuModule = _m
		module.quit_module()
