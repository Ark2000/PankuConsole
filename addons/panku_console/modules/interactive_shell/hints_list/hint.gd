extends PanelContainer

@export var label:RichTextLabel
@export var bg2:ColorRect

func set_highlight(b:bool):
	bg2.scale.x = 1.0 if b else 0.0
	bg2.visible = b
