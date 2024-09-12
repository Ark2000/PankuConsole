class_name PankuModuleEngineTools extends PankuModule

func init_module():
	get_module_opt().count_nodes = load_module_data("count_nodes", false)
	super.init_module()

func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	core.notify("Fullscreen: " + str(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN))

func set_time_scale(val:float) -> void:
	Engine.time_scale = val

class ClsCountNodesInTree:
	func calc_children_count(core: PankuConsole, node_path: String) -> int:
		var nd: Node = core.get_tree().current_scene.get_node(node_path)
		return count_all_children(nd)
	func count_all_children(nd: Node) -> int:
		var count: int = nd.get_children().size()
		for child: Node in nd.get_children():
			count += count_all_children(child)
		return count

func get_performance_info(count_nodes:bool) -> String:
	var result = "FPS: %d | Mem: %.2fMB | Objs: %d" % [
		Engine.get_frames_per_second(),
		OS.get_static_memory_usage()/1048576.0,
		Performance.get_monitor(Performance.OBJECT_COUNT)
	]
	if count_nodes:
		var cls_count: ClsCountNodesInTree = ClsCountNodesInTree.new()
		var root_count: int = cls_count.calc_children_count(core, "/root")
		var panku_count: int = cls_count.calc_children_count(core, "/root/Panku")
		result += " | Nodes: %d" % [root_count - panku_count]
	return result

func take_screenshot() -> void:
	var image = core.get_viewport().get_texture().get_image()
	var time = str(int(Time.get_unix_time_from_system() * 1000.0))
	var file_name = "screenshot_%s.png" % time
	var path = "user://".path_join(file_name)
	var real_path = OS.get_user_data_dir().path_join(file_name)
	image.save_png(path)
	core.notify("[b]Screenshot[/b] saved at [color=green][url=%s]%s[/url][/color]" % [real_path, real_path])

func quit() -> void:
	core.get_tree().root.propagate_notification(core.NOTIFICATION_WM_CLOSE_REQUEST)
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
