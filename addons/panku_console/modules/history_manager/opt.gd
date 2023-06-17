extends Resource

var _module:PankuModule

@export_group("history_manager")

@export var export_button_open_window := "Open Window"
func open_window():
	_module.open_window()
