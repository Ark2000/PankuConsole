#A simple control node managing its child windows
extends Control

func _input(e):
	if e is InputEventMouseButton and e.pressed:
		var flag = true
		#traverse child windows in reverse order, use double shadow to highlight current active window.
		for i in range(get_child_count() - 1, -1, -1):
			var w:PankuConsole.LynxWindow2 = get_child(i)
			if w.visible and w.get_global_rect().has_point(get_global_mouse_position()):
				get_child(get_child_count() - 1)._shadow_focus.hide()
				w.move_to_front()
				get_child(get_child_count() - 1)._shadow_focus.show()
				flag = false
				break
		if flag:
			get_child(get_child_count() - 1)._shadow_focus.hide()
