class_name PankuModuleScreenCrtEffect extends PankuModule

var crt_effect_enabled := false
var crt_effect_layer:CanvasLayer = null

func toggle_crt_effect():
	crt_effect_enabled = !crt_effect_enabled
	if crt_effect_layer == null:
		crt_effect_layer = preload("./crt_effect_layer.tscn").instantiate()
		core.add_child(crt_effect_layer)
	crt_effect_layer.visible = crt_effect_enabled
