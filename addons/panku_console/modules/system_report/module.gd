class_name PankuModuleSystemReport extends PankuModule

func get_module_name():
	return "SystemReport"

func init_module():
	var wrapper = preload("./env.gd").new()
	wrapper._core = core
	core.gd_exprenv.register_env("system_report", wrapper)
