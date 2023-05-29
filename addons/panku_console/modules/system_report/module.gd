class_name PankuModuleSystemReport extends PankuModule

func get_module_name():
	return "SystemReport"

func init_module():
	var wrapper = preload("./env.gd").new()
	wrapper._core = core
	core.register_env("system_report", wrapper)
