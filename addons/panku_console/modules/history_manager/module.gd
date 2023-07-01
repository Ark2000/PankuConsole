class_name PankuModuleHistoryManager extends PankuModule

var window:PankuLynxWindow

func init_module():
	# setup ui
	var ui = preload("./exp_history.tscn").instantiate()
	ui.console = core
	core.new_expression_entered.connect(
		func(expression, result):
			ui.add_history(expression)
	)

	# bind window
	window = core.windows_manager.create_window(ui)
	window.queue_free_on_close = false
	window.set_window_title_text("History Manager")
	load_window_data(window)

func quit_module():
	save_window_data(window)

func open_window():
	window.show_window()
