extends HBoxContainer

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)

signal submitted(exp:String)
signal update_hints(exp:String)
signal next_hint()
signal prev_hint()
signal navigate_histories(histories:Array, cur:int)

@export var input:LineEdit
@export var btn:Button

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
			if is_visible_in_tree():
				input.call_deferred("grab_focus")
	)
