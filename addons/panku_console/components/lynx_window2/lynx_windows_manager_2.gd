#A simple control node managing its child windows
extends Control

func _input(e):
	if e is InputEventMouseButton and e.pressed:
		var flag = true
		#traverse child windows in reverse order, use double shadow to highlight current active window.
		for i in range(get_child_count() - 1, -1, -1):
			var w:Control = get_child(i)
			if w.visible and w.get_global_rect().has_point(get_global_mouse_position()):
				var forefront = get_child(get_child_count() - 1)
				if forefront.has_method("highlight"): forefront.highlight(false)
				w.move_to_front()
				forefront = get_child(get_child_count() - 1)
				if forefront.has_method("highlight"): forefront.highlight(true)
				flag = false
				break
		if flag and get_child_count() > 0:
			var forefront = get_child(get_child_count() - 1)
			if forefront.has_method("highlight"): forefront.highlight(false)
