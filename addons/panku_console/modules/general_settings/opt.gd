extends ModuleOptions

@export_group("general_settings")

@export var window_blur_effect:bool = true:
	set(v):
		PankuLynxWindow.lynx_window_shader_material.set("shader_parameter/lod", 4.0 if v else 0.0)
	get:
		return PankuLynxWindow.lynx_window_shader_material.get("shader_parameter/lod") > 0.0

@export var window_base_color:Color = Color(0.0, 0.0, 0.0, 0.1):
	set(v):
		PankuLynxWindow.lynx_window_shader_material.set("shader_parameter/modulate", v)
	get:
		return PankuLynxWindow.lynx_window_shader_material.get("shader_parameter/modulate")

@export var enable_os_window := false:
	set(v):
		_module.core.windows_manager.enable_os_popup_btns(v)
	get:
		return _module.core.windows_manager.os_popup_btn_enabled

@export var os_window_bg_color:Color:
	set(v):
		_module.core.windows_manager.set_os_window_bg_color(v)
	get:
		return _module.core.windows_manager.os_window_bg_color

@export var export_button_report_bugs := "Report Bugs"
func report_bugs():
	OS.shell_open("https://github.com/Ark2000/PankuConsole/issues")

@export var export_button_suggest_features := "Suggest Features"
func suggest_features():
	OS.shell_open("https://github.com/Ark2000/PankuConsole/issues")
