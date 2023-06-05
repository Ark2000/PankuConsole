extends VBoxContainer

var console:PankuConsole

@export var input_area:Node
@export var repl:Node

func _ready() -> void:
	repl.output.connect(
		func(text:String) -> void:
			console.notify(text)
	)
	input_area.submitted.connect(
		func(_s): hide()
	)
