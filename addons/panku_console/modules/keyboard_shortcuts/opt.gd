extends Resource
var _module:PankuModule

@export_group("keyboard_shortcuts")

@export var export_button_open_keyboard_shortcuts := "Open Keyboard Shortcuts"

func open_keyboard_shortcuts():
	_module.open_window()
