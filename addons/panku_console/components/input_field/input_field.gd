extends LineEdit

const MAX_HISTORY = 10

#up/down history
var histories := []
var history_idx := 0

var hints = []

func _ready():
	text_submitted.connect(on_text_submitted)

func on_text_submitted(s:String):
	if histories.size() > 0 and history_idx < histories.size() and text == histories[history_idx]:
		pass
	else:
		if histories.size() >= MAX_HISTORY:
			histories.pop_front()
		histories.push_back(text)
	history_idx = histories.size()
	clear()
	Console.exp_history_window.get_content().add_history(s)

func _gui_input(e):
	#navigate through histories
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
