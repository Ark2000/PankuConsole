extends HBoxContainer

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)

signal submitted(exp:String)
signal update_hints(exp:String)
signal next_hint()
signal prev_hint()
signal navigate_histories(histories:Array, cur:int)

@export var input:LineEdit
@export var btn:Button
@export var menubtn:MenuButton

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
				pass
				# var window = console.add_monitor_window(exp, 0.1)
				# window.centered()
			#add button
			elif id == 1:
				pass
				# var window = console.add_monitor_window(exp, 999999)
				# window.centered()
	)
