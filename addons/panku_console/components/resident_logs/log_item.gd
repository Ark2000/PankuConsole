extends HBoxContainer

var amount := 1:
	set(v):
		amount = v
		amount_pop_anim()

@onready var content_label:RichTextLabel = $Content/MarginContainer/RichTextLabel
@onready var amount_label:Label = $Amount/MarginContainer/Label
@onready var amount_panel:PanelContainer = $Amount

var tween2:Tween

func amount_pop_anim():
	if tween2 and tween2.is_valid():
		tween2.kill()
	tween2 = get_tree().create_tween()
	tween2.tween_property(amount_panel, "scale", Vector2(1, 1), 0.01)
	tween2.tween_property(amount_panel, "scale", Vector2(1.2, 1.2), 0.05)
	tween2.tween_property(amount_panel, "scale", Vector2(1, 1), 0.05)

func _ready():
	content_label.meta_clicked.connect(
		func(meta):
			OS.shell_open(str(meta))
	)

	await get_tree().process_frame
	var tween = get_tree().create_tween()
	modulate.a = 0.0
	position.x -= size.x / 2
	tween.tween_property(self, "position:x", size.x / 2, 0.2).as_relative().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.set_parallel().tween_property(self, "modulate:a", 1.0, 0.2).as_relative().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
