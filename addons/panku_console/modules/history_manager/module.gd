class_name PankuModuleHistoryManager extends PankuModule
func get_module_name(): return "HistoryManager"

var window:PankuLynxWindow

func init_module():

	# register env
	var env = preload("./env.gd").new()
	env._module = self
	core.gd_exprenv.register_env("history_manager", env)

	# setup ui
	var ui = preload("./exp_history.tscn").instantiate()
	ui.console = core
	core.new_expression_entered.connect(
		func(expression):
			ui.add_history(expression)
	)

	# bind window
	window = core.windows_manager.create_window(ui)
	window.queue_free_on_close = false
	window.set_caption("History Manager")
	load_window_data(window)

func quit_module():
	save_window_data(window)
