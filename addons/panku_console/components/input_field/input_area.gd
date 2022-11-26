extends HBoxContainer

signal submitted(env:String, exp:String)

@onready var opt:OptionButton = $OptionButton
@onready var input:LineEdit = $InputField
@onready var btn:Button = $Button

func _ready():
	input.text_submitted.connect(
		func(s):
			submitted.emit(opt.get_item_text(opt.selected), s)
	)
	btn.pressed.connect(
		func():
			submitted.emit(opt.get_item_text(opt.selected), input.text)
			input.on_text_submitted(input.text)
	)
	#get focus automatically.
	visibility_changed.connect(
		func():
			if visible:
				input.grab_focus()
	)

var options = {}

func add_option(s:String):
	opt.add_item(s)
	options[s] = opt.item_count - 1
	assert(opt.get_item_text(opt.item_count - 1) == s)

func remove_option(s:String):
	if options.has(s):
		opt.remove_item(options[s])
		options.erase(s)

func clear_options():
	opt.clear()
	options.clear()
