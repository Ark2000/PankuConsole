class_name PankuModuleEngineTools extends PankuModule
func get_module_name(): return "EngineTools"

func init_module():
    var env := preload("env.gd").new()
    env._console = core
    core.register_env("engine_tools", env)
