class_name PankuModuleEngineTools extends PankuModule

func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	core.notify("Fullscreen: " + str(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN))

func set_time_scale(val:float) -> void:
	Engine.time_scale = val

func get_performance_info() -> String:
	return "FPS: %d | Mem: %.2fMB | Objs: %d" % [Engine.get_frames_per_second(), OS.get_static_memory_usage()/1048576.0, Performance.get_monitor(Performance.OBJECT_COUNT)]

func take_screenshot() -> void:
	var image = core.get_viewport().get_texture().get_image()
	var time = str(int(Time.get_unix_time_from_system() * 1000.0))
	var file_name = "screenshot_%s.png" % time
	var path = "user://".path_join(file_name)
	var real_path = OS.get_user_data_dir().path_join(file_name)
	image.save_png(path)
	core.notify("[b]Screenshot[/b] saved at [color=green][url=%s]%s[/url][/color]" % [real_path, real_path])

func quit() -> void:
	core.get_tree().quit()

# Currently godot can't toggle visibility of 2D collision shapes at runtime, this is a workaround.
# See https://github.com/godotengine/godot-proposals/issues/2072
func toggle_2d_collision_shape_visibility() -> void:
	var tree := core.get_tree()
	tree.debug_collisions_hint = not tree.debug_collisions_hint

	# Traverse tree to call queue_redraw on instances of
	# CollisionShape2D and CollisionPolygon2D.
	var node_stack: Array[Node] = [tree.get_root()]
	while not node_stack.is_empty():
		var node: Node = node_stack.pop_back()
		if is_instance_valid(node):
			if node is CollisionShape2D or node is CollisionPolygon2D:
				node.queue_redraw()
			node_stack.append_array(node.get_children())
	core.notify("2D Debug Draw: " + str(tree.debug_collisions_hint))

func reload_current_scene() -> void:
	core.get_tree().reload_current_scene()
	core.notify("Scene reloaded")
