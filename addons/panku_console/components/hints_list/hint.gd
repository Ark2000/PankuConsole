extends Button

@onready var icon2:TextureRect = $HBoxContainer/MarginContainer/Icon
@onready var label:RichTextLabel = $HBoxContainer/RichTextLabel
@onready var bg2:ColorRect = $Bg2

func set_highlight(b:bool):
	if b:
		create_tween().tween_property(bg2, "scale:x", 1.0, 0.01).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		create_tween().tween_property(bg2, "scale:x", 0.0, 0.01).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
