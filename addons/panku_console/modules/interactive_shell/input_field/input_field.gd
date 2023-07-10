extends LineEdit

var module:PankuModuleInteractiveShell

#up/down history
var history_idx := 0

var hints = []

func _ready():
	text_submitted.connect(on_text_submitted)

func on_text_submitted(s:String):
	var histories = module.get_histories()
	if histories.size() > 0 and history_idx < histories.size() and text == histories[history_idx]:
		pass
	else:
		module.add_history(s)
	history_idx = histories.size()
	clear()

func _gui_input(e):
	#navigate through histories
	var histories = module.get_histories()
	if hints.is_empty():
		if e is InputEventKey and e.keycode == KEY_UP and e.pressed:
			if !histories.is_empty() :
				history_idx = wrapi(history_idx-1, 0, histories.size())
				text = histories[history_idx]
				get_parent().navigate_histories.emit(histories, history_idx)
				await get_tree().process_frame
				caret_column = text.length()
		elif e is InputEventKey and e.keycode == KEY_DOWN and e.pressed:
			if !histories.is_empty():
				history_idx = wrapi(history_idx+1, 0, histories.size())
				text = histories[history_idx]
				get_parent().navigate_histories.emit(histories, history_idx)
				await get_tree().process_frame
				caret_column = text.length()
	#navigate through hints
	else:
		if e is InputEventKey and e.keycode == KEY_UP and e.pressed:
			get_parent().prev_hint.emit()
		elif e is InputEventKey and (e.keycode in [KEY_DOWN, KEY_TAB]) and e.pressed:
			get_parent().next_hint.emit()
