extends LineEdit

const MAX_HISTORY = 10

#up/down history
var histories := []
var history_idx := 0

func _ready():
	text_submitted.connect(on_text_submitted)

func on_text_submitted(s):
	if histories.size() > 0 and history_idx < histories.size() and text == histories[history_idx]:
		pass
	else:
		if histories.size() >= MAX_HISTORY:
			histories.pop_front()
		histories.push_back(text)
	history_idx = histories.size()
	clear()

func _gui_input(e):
	if e is InputEventKey and e.keycode == KEY_UP and e.pressed:
		if !histories.is_empty() and history_idx > 0:
			history_idx -= 1
			history_idx = clamp(history_idx, 0, histories.size() - 1)
			text = histories[history_idx]
			await get_tree().process_frame
			caret_column = text.length()
	elif e is InputEventKey and e.keycode == KEY_DOWN and e.pressed:
		if !histories.is_empty() and history_idx < histories.size() - 1:
			history_idx += 1
			history_idx = clamp(history_idx, 0, histories.size() - 1)
			text = histories[history_idx]
			await get_tree().process_frame
			caret_column = text.length()
