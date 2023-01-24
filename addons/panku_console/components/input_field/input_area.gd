extends HBoxContainer

signal submitted(exp:String)
signal update_hints(exp:String)
signal next_hint()
signal prev_hint()
signal navigate_histories(histories:Array, cur:int)

@export var input:LineEdit
@export var btn:Button
@export var menubtn:MenuButton
@export var btn2:Button

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
	btn2.pressed.connect(
		func():
			Console.add_exporter_window(Console.options, "Panku Settings")
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
	menubtn.about_to_popup.connect(
		func():
			var popup = menubtn.get_popup()
			popup.set_item_checked(popup.get_item_index(2), Console.mini_repl_mode)
	)

	Console.repl_visible_about_to_change.connect(
		func(_is_visible:bool):
			input.editable = false
	)
	Console.repl_visible_changed.connect(
		func(_is_visible:bool):
			input.editable = true
	)
