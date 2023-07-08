var _module:PankuModule

const _HELP_open = "Open logger window"
func open() -> void:
	_module.open_window()

const _HELP_toggle_overlay = "Toggle visibility of logger overlay"
func toggle_overlay() -> void:
	_module.toggle_overlay()

const _HELP_clear = "Clear logs"
func clear() -> void:
	_module.logger_ui.clear_all()
