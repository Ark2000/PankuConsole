extends MarginContainer

@export var rlabel:RichTextLabel

#not sure about the performance
const MAX_LOGS = 400

func _ready():
	rlabel.meta_clicked.connect(
		func(meta):
			OS.shell_open(meta)
	)

func add_log(bbcode:String):
	rlabel.text += (bbcode + "\n")

func clear():
	rlabel.text = ""

func set_font_size(sz:int):
	rlabel.set("theme_override_font_sizes/normal_font_size", sz)
	rlabel.set("theme_override_font_sizes/bold_font_size", sz)
	rlabel.set("theme_override_font_sizes/italics_font_size", sz)
	rlabel.set("theme_override_font_sizes/bold_italics_font_size", sz)
	rlabel.set("theme_override_font_sizes/mono_font_size", sz)

func get_font_size() -> int:
	return rlabel.get("theme_override_font_sizes/normal_font_size")
