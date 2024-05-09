extends HBoxContainer

@export var label:Label

func _ready():
	$PankuButton.pressed.connect(
		func():
			Panku.notify(label.text)
	)
