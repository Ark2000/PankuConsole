var _module:PankuModuleNativeLogger

const _HELP_open = "Open logger window"
func open() -> void:
	pass
	_module.window.centered()
	_module.window.move_to_front()
	_module.window.show()

const _HELP_toggle_overlay = "Toggle visibility of logger overlay"
func toggle_overlay() -> void:
	_module.output_overlay.visible = not _module.output_overlay.visible
