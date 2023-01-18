extends PankuConsole.ExporterRowUI

@export var ledit:LineEdit

func update_ui(val):
	ledit.text = str(val)
