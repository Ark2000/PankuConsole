extends Resource

@export_group("engine_tools")

var _module:PankuModule

@export var export_button_toggle_fullscreen := "Check Update"

func toggle_fullscreen():
	_module.env.toggle_fullscreen
