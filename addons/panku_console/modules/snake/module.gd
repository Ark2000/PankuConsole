class_name PankuModuleSnakeGame extends PankuModule

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
