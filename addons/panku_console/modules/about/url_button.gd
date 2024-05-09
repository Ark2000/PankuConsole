extends Button

@export var url:String

func _ready():
	pressed.connect(
		func():
			OS.shell_open(url)
	)
