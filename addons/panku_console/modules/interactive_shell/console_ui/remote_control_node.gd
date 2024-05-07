extends Control

@export
var target_control:Control

func _ready():
	if not target_control:
		return
		
	target_control.resized.connect(
		func():
			custom_minimum_size = target_control.get_minimum_size()
	)
	
	target_control.resized.emit()
