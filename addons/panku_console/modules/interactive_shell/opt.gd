extends ModuleOptions

@export_group("interactive_shell")

@export var export_comment_unified_visibility = "unified_visibility will keep all windows' visibility the same as interative shell"
@export var unified_visibility:bool = false:
	get:
		return _module.unified_window_visibility
	set(v):
		_module.set_unified_window_visibility(v)

@export var export_comment_pause_if_popup = "Whether the whole game should be paused when interactive shell is visible"
@export var pause_if_popup:bool = false:
	get:
		return _module.pause_if_input
	set(v):
		_module.set_pause_if_popup(v)

@export_range(12,20) var output_font_size:int:
	set(v):
		_module.interactive_shell._console_logs.set_font_size(v)
	get:
		return _module.interactive_shell._console_logs.get_font_size()

@export var export_comment_init_expression = "init_expression will be executed when the project starts"
@export var init_expression:String = "":
	get:
		return _module.init_expr
	set(v):
		_module.init_expr = v
