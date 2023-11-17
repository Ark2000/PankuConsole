extends HBoxContainer

var life = 2.0

var amount := 1:
	set(v):
		amount = v
		amount_pop_anim()

@export var content_label:RichTextLabel
@export var amount_label:Label
@export var amount_panel:PanelContainer

@export var progress_a:Panel
@export var progress_b:Control

var tween2:Tween
var tween3:Tween

func amount_pop_anim():
	if tween2 and tween2.is_valid():
		tween2.kill()
	tween2 = create_tween()
	tween2.tween_property(amount_panel, "scale", Vector2(1, 1), 0.01)
	tween2.tween_property(amount_panel, "scale", Vector2(1.2, 1.2), 0.05)
	tween2.tween_property(amount_panel, "scale", Vector2(1, 1), 0.05)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free).set_delay(0.2)

func set_progress(v:float):
	progress_a.size_flags_stretch_ratio = v
	progress_b.size_flags_stretch_ratio = 1.0 - v

func _ready():
	content_label.meta_clicked.connect(
		func(meta):
			OS.shell_open(str(meta))
	)
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)

	tween3 = create_tween()
	tween3.tween_method(set_progress, 1.0, 0.0, life)
	tween3.tween_callback(fade_out)
