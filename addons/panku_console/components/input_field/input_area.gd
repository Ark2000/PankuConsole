extends HBoxContainer

signal submitted(exp:String)
signal update_hints(exp:String)
signal next_hint()
signal prev_hint()
signal navigate_histories(histories:Array, cur:int)

@onready var input:LineEdit = $InputField
@onready var btn:Button = $Button

func _ready():
	input.text_submitted.connect(
		func(s):
			submitted.emit(s)
	)
	input.text_changed.connect(
		func(s):
			update_hints.emit(s)
	)
	btn.pressed.connect(
		func():
			submitted.emit(input.text)
			input.on_text_submitted(input.text)
	)
	#get focus automatically.
	visibility_changed.connect(
		func():
			if visible:
				input.grab_focus()
	)
