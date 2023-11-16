class_name PankuModuleAbout extends PankuModule

var window:PankuLynxWindow
const ui = preload("./about.tscn")

func open_window():
	if window: return
	var ui_instance = ui.instantiate()
	ui_instance._module = self
	window = core.windows_manager.create_window(ui_instance)
	window.set_window_title_text("About")
	window.show_window()
	window.window_closed.connect(
		func(): window = null
	)
