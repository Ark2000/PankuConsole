extends ModuleOptions

@export_group("native_logger")

@export var export_button_open_window := "Open Logger Window"
func open_window():
	_module.open_window()

@export var export_comment_1 = "The logger is built upon the native engine file logging utility."

@export var export_button_open_engine_log_folder:String = "Open Engine Logs Folder"

@export_enum("Always Show", "Show If Shell Visible", "Never Show") var screen_overlay:int:
	set(v):
		_module.set_overlay_display_mode(v)
	get:
		return _module.output_overlay_display_mode

@export var show_timestamp:bool = true:
	set(v):
		_module.set_show_timestamp(v)
	get:
		return _module.show_timestamp

@export_range(0.0, 1.0, 0.01) var screen_overlay_alpha:float = 0.5:
	set(v):
		_module.output_overlay.modulate.a = v
	get:
		return _module.output_overlay.modulate.a

@export var screen_overlay_override_font_size:int = 0:
	set(v):
		var overlay:RichTextLabel = _module.output_overlay
		if (v <= 0):
			overlay.remove_theme_font_size_override("normal_font_size")
			overlay.remove_theme_font_size_override("bold_font_size")
			overlay.remove_theme_font_size_override("italics_font_size")
			overlay.remove_theme_font_size_override("bold_italics_font_size")
			overlay.remove_theme_font_size_override("mono_font_size")
		else:
			overlay.add_theme_font_size_override("normal_font_size", v)
			overlay.add_theme_font_size_override("bold_font_size", v)
			overlay.add_theme_font_size_override("italics_font_size", v)
			overlay.add_theme_font_size_override("bold_italics_font_size", v)
			overlay.add_theme_font_size_override("mono_font_size", v)
	get:
		#return _module.output_overlay.theme.default_font_size
		var overlay:RichTextLabel = _module.output_overlay
		if overlay.has_theme_font_size_override("normal_font_size"):
			return overlay.get("theme_override_font_sizes/normal_font_size")
		return 0

@export var screen_overlay_font_shadow:bool = false:
	set(v):
		var val = Color.BLACK if v else null
		_module.output_overlay.set("theme_override_colors/font_shadow_color", val)
	get:
		return _module.output_overlay.get("theme_override_colors/font_shadow_color") != null

func open_engine_log_folder():
	OS.shell_open(ProjectSettings.globalize_path(ProjectSettings.get_setting("debug/file_logging/log_path").get_base_dir()))
