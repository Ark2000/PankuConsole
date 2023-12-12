class_name PankuModuleSnakeGame extends PankuModule

var leader_board_arr = []

func init_module():
	leader_board_arr = load_module_data("leader_board", [])

func add_snake_window():
	var snake_ui := preload("res://addons/panku_console/modules/snake/snake.tscn").instantiate()
	var window:PankuLynxWindow = core.windows_manager.create_window(snake_ui)
	window.queue_free_on_close = true
	window.set_window_title_text("Snake Game")
	window.position = window.get_layout_position(Control.PRESET_CENTER)
	window.move_to_front()
	window.size = Vector2(
		snake_ui.snake_game.MAP_SIZE * snake_ui.CELL_SIZE, 0)
	window.size.y = window.size.x + 24
	
	core.get_tree().root.get_viewport().gui_release_focus()

	snake_ui.snake_game.game_over.connect(
		func():
			var record = {
				"timestamp": Time.get_datetime_string_from_system(),
				"score": snake_ui.snake_game.get_snake_length()
			}
			leader_board_arr.append(record)
			leader_board_arr.sort_custom(
				func(a, b):
					return a['score'] > b['score']
			)

			if leader_board_arr.size() > 10:
				leader_board_arr.resize(10)

			save_module_data("leader_board", leader_board_arr)
	)
