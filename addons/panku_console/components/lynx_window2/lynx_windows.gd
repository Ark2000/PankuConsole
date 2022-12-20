extends Control

func _input(e):
	if e is InputEventMouseButton and e.pressed:
		var flag = true
		for i in range(get_child_count() - 1, -1, -1):
			var w = get_child(i)
			if w.visible and w.get_global_rect().has_point(get_global_mouse_position()):
				get_child(get_child_count() - 1).border.hide()
				w.move_to_front()
				get_child(get_child_count() - 1).border.show()
				flag = false
				break
		if flag:
			get_child(get_child_count() - 1).border.hide()
