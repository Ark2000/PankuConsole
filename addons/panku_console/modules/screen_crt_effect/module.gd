class_name PankuModuleScreenCrtEffect extends PankuModule
func get_module_name(): return "ScreenCrtEffect"

var crt_effect_enabled := false
var crt_effect_layer:CanvasLayer = null

func toggle_crt_effect():
	crt_effect_enabled = !crt_effect_enabled
	if crt_effect_layer == null:
		crt_effect_layer = preload("./crt_effect_layer.tscn").instantiate()
		core.add_child(crt_effect_layer)
	crt_effect_layer.visible = crt_effect_enabled

func init_module():
	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.register_env("screen_crt_effect", env)
