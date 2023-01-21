extends Control

@export var label:RichTextLabel
@export var settings_ui:Node
@export var close_btn:Node
@export var freq_label:Node
@export var freq_slider:Node
@export var freq_confirm:Node
@export var exp_ledit:Node
@export var exp_confirm:Node
@export var title_ledit:Node
@export var title_confirm:Node

var update_period = 999999
var update_exp = "engine.performance_info"
var title_text = ""
var t = 0.0

func toggle_settings():
	settings_ui.visible = !settings_ui.visible

func update_exp_i():
	label.text = str(Console.execute(update_exp)["result"])

func _ready():
	t = update_period
	freq_slider.value = floor(1.0 / update_period)
	freq_label.text = "%d/s"%freq_slider.value
	exp_ledit.text = update_exp
	title_ledit.text = title_text

	close_btn.pressed.connect(
		func():
			settings_ui.hide()
	)
	freq_slider.value_changed.connect(
		func(val):
			freq_label.text = "%d/s"%val
	)
	freq_confirm.pressed.connect(
		func():
			update_period = 1.0 / max(0.000001, freq_slider.value)
			t = update_period
	)
	exp_confirm.pressed.connect(
		func():
			update_exp = exp_ledit.text
			title_ledit.text = update_exp
			title_text = update_exp
	)
	

func _process(delta):
	t -= delta
	if t <= 0.0:
		label.text = str(Console.execute(update_exp)["result"])
		t += update_period

#func _notification(what):
#	#quit event
#	if what == NOTIFICATION_WM_CLOSE_REQUEST:
#		var cfg = PankuConsole.Config.get_config()
#		cfg["widgets_data"].push_back({
#			"exp": update_exp,
#			"position": position,
#			"size": size,
#			"period": update_period,
#			"title": title_text
#		})
#		PankuConsole.Config.set_config(cfg)
