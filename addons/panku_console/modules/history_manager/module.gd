class_name PankuModuleHistoryManager extends PankuModule
func get_module_name(): return "HistoryManager"

var window:PankuLynxWindow

func init_module():

	# register env
	var env = preload("./history_manager.gd").new()
	env._module = self
	core.register_env("history_manager", env)

	# setup ui
	var ui = preload("./exp_history.tscn").instantiate()
	core.new_expression_entered.connect(
		func(expression):
			ui.add_history(expression)
	)

	# bind window
	window = core.create_window(ui)
	window.queue_free_on_close = false
	window.set_caption("History Manager")
	window.hide_options_button()
	window.hide()
