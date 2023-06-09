extends "./row_ui.gd"

@export var ledit:LineEdit

func update_ui(val):
	ledit.text = str(val)
