extends Button

signal key_event_changed(new_event:InputEventKey)

var key_event:InputEventKey:
	set(v):
		key_event = v
		var key_name = "unassigned"
		if key_event:
			key_name = "Key " + OS.get_keycode_string(key_event.keycode)
		text = key_name
		key_event_changed.emit(v)

func _ready():
	set_process_unhandled_key_input(false)
	toggled.connect(
		func(button_pressed:bool):
			set_process_unhandled_key_input(button_pressed)
			if button_pressed:
				text = "Waiting..."
			else:
				release_focus()
	)

func _unhandled_key_input(event):
	key_event = event
	button_pressed = false
