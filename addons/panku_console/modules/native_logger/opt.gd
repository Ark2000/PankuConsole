extends Resource
var _module:PankuModule

@export_group("native_logger")

@export var export_button_open_window := "Open Logger Window"
func open_window():
	_module.open_window()

@export var export_comment_1 = "The logger is built upon the native engine file logging utility."

@export var export_button_open_engine_log_folder:String = "Open Engine Logs Folder"

@export_range(12, 20) var font_size:int = 14:
	set(v):
		_module.logger_ui.rlabel.theme.default_font_size = v
	get:
		return _module.logger_ui.rlabel.theme.default_font_size

@export var screen_overlay:bool = true:
	set(v):
		_module.output_overlay.visible = v
	get:
		return _module.output_overlay.visible
@export_range(0.0, 1.0, 0.01) var screen_overlay_alpha:float = 0.5:
	set(v):
		_module.output_overlay.modulate.a = v
	get:
		return _module.output_overlay.modulate.a
@export_range(8, 24) var screen_overlay_font_size:int = 16:
	set(v):
		_module.output_overlay.theme.default_font_size = v
	get:
		return _module.output_overlay.theme.default_font_size
@export var screen_overlay_font_shadow:bool = false:
	set(v):
		var val = Color.BLACK if v else null
		_module.output_overlay.set("theme_override_colors/font_shadow_color", val)
	get:
		return _module.output_overlay.get("theme_override_colors/font_shadow_color") != null

func open_engine_log_folder():
	OS.shell_open(ProjectSettings.globalize_path(ProjectSettings.get_setting("debug/file_logging/log_path").get_base_dir()))
