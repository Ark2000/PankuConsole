extends Resource

var _module:PankuModule

@export_group("screen_crt_effect")

@export var export_button_toggle_crt_effect:String = "Toggle Effect"

func toggle_crt_effect():
	_module.toggle_crt_effect()

func set_unified_window_visibility(enabled:bool):
	_module.unified_window_visibility = enabled
	_module.update_gui_state()

func set_pause_if_popup(enabled:bool):
	_module.pause_if_input = enabled
	_module.update_gui_state()
