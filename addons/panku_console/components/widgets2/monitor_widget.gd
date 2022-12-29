class_name MonitorWidget
extends LynxWindow

@onready var label:RichTextLabel = $Body/Content/RichTextLabel
@onready var settings_btn:Button = $Body/Title/SettingsBtn
@onready var settings_ui := $Body/Content/SettingsUI
@onready var close_btn := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/Button
@onready var freq_label := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/HBoxContainer/Label2
@onready var freq_slider := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/HBoxContainer/HSlider
@onready var freq_confirm := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/HBoxContainer/Button
@onready var exp_ledit := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/HBoxContainer2/LineEdit
@onready var exp_confirm := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/HBoxContainer2/Button
@onready var title_ledit := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/HBoxContainer3/LineEdit
@onready var title_confirm := $Body/Content/SettingsUI/MarginContainer/VBoxContainer/HBoxContainer3/Button


var update_period = 999999
var update_exp = "engine.performance_info"
var title_text = ""
var t = 0.0

func _ready():
	super._ready()
	t = update_period
	freq_slider.value = floor(1.0 / update_period)
	freq_label.text = "%d/s"%freq_slider.value
	exp_ledit.text = update_exp
	title_ledit.text = title_text
	title_label.text = title_text
	tsp_group.append(settings_btn)

	close_window.connect(
		func():
			queue_free()
	)
	#update the exp immediately
	title_clicked_left.connect(
		func():
			label.text = str(Console.execute(update_exp)["result"])
	)
	settings_btn.pressed.connect(
		func():
			settings_ui.visible = !settings_ui.visible
	)
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
			title_label.text = update_exp
			title_ledit.text = update_exp
			title_text = update_exp
	)
	title_confirm.pressed.connect(
		func():
			title_label.text = title_ledit.text
			title_text = title_label.text
	)
	
	await get_tree().process_frame
	print(label.get_minimum_size())
	

func _process(delta):
	super._process(delta)
	t -= delta
	if t <= 0.0:
		label.text = str(Console.execute(update_exp)["result"])
		t += update_period

func _notification(what):
	#quit event
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var cfg = PankuConfig.get_config()
		cfg["widgets_data"].push_back({
			"exp": update_exp,
			"position": position,
			"size": size,
			"period": update_period,
			"title": title_text
		})
		PankuConfig.set_config(cfg)
