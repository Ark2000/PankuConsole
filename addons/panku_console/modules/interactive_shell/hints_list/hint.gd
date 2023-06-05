extends Button

@export var label:RichTextLabel
@export var bg2:ColorRect

func set_highlight(b:bool):
	if b:
		create_tween().tween_property(bg2, "scale:x", 1.0, 0.01).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		create_tween().tween_property(bg2, "scale:x", 0.0, 0.01).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
