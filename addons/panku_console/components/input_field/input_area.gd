extends HBoxContainer

signal submitted(exp:String)
signal update_hints(exp:String)
signal next_hint()
signal prev_hint()
signal navigate_histories(histories:Array, cur:int)

@onready var input:LineEdit = $InputField
@onready var btn:Button = $Button
@onready var menubtn:MenuButton = $MenuButton

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

	menubtn.mouse_entered.connect(
		func():
			menubtn.modulate = Color.GREEN
	)
	menubtn.mouse_exited.connect(
		func():
			menubtn.modulate = Color.WHITE
	)
	menubtn.get_popup().id_pressed.connect(
		func(id:int):
			#watch
			var exp = input.text.lstrip(" ").rstrip(" ")
			if id == 0:
				Console.execute("widgets.watch('%s')"%exp)
			#add button
			elif id == 1:
				Console.execute("widgets.button('%s', '%s')"%[exp, exp])
	)
