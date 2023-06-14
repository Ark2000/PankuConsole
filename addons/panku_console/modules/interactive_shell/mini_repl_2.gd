extends VBoxContainer

var console:PankuConsole

@export var input_area:Node
@export var repl:Node

func _ready() -> void:
	repl.output_result.connect(console.notify)
	repl.output_error.connect(console.notify)
	input_area.submitted.connect(
		func(_s): hide()
	)
