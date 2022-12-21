extends Control

func _input(e):
	if e is InputEventMouseButton and e.pressed:
		var flag = true
		for i in range(get_child_count() - 1, -1, -1):
			var w = get_child(i)
			if w.visible and w.get_global_rect().has_point(get_global_mouse_position()):
				if get_child(get_child_count() - 1).no_border:
					get_child(get_child_count() - 1).border.self_modulate.a = 0.0
				else:
					get_child(get_child_count() - 1).border.self_modulate.a = 0.25
				w.move_to_front()
				get_child(get_child_count() - 1).border.self_modulate.a = 0.5
				flag = false
				break
		if flag:
			if get_child(get_child_count() - 1).no_border:
				get_child(get_child_count() - 1).border.self_modulate.a = 0.0
			else:
				get_child(get_child_count() - 1).border.self_modulate.a = 0.25
