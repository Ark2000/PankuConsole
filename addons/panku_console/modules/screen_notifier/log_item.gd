extends HBoxContainer

var life = 2.0

var amount := 1:
	set(v):
		amount = v
		play_amount_pop_animation()

@export var content_label:RichTextLabel
@export var amount_label:Label
@export var amount_panel:PanelContainer

@export var progress_a:Panel
@export var progress_b:Control

var amount_pop_tween:Tween
var life_tween:Tween

func play_amount_pop_animation():
	if amount_pop_tween: amount_pop_tween.kill()
	amount_pop_tween = create_tween()
	amount_pop_tween.tween_property(amount_panel, "scale", Vector2(1, 1), 0.01)
	amount_pop_tween.tween_property(amount_panel, "scale", Vector2(1.2, 1.2), 0.05)
	amount_pop_tween.tween_property(amount_panel, "scale", Vector2(1, 1), 0.05)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free).set_delay(0.2)

func set_progress(v:float):
	progress_a.size_flags_stretch_ratio = v
	progress_b.size_flags_stretch_ratio = 1.0 - v
	
func play_lifespan_animation():
	# interrupt and clear current tween animation
	if life_tween: life_tween.kill()
	life_tween = create_tween()
	# create new tween animations
	life_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	life_tween.set_parallel(true)
	life_tween.tween_method(set_progress, 1.0, 0.0, life)
	life_tween.set_parallel(false)
	life_tween.tween_property(self, "modulate:a", 0.0, 0.2)
	life_tween.tween_callback(queue_free).set_delay(0.2)
	

func _ready():
	content_label.meta_clicked.connect(
		func(meta):
			OS.shell_open(str(meta))
	)
	play_lifespan_animation()
