extends MarginContainer

@onready var body_btn = $Button
@onready var close_btn = $HBoxContainer/Button
@onready var widget_label = $HBoxContainer/Label

var _is_dragging := false
var _drag_start_position:Vector2
var _drag_start_position_global:Vector2

var get_widget_text:Callable
var btn_pressed:Callable
var update_delay = 0.2

func _ready():
	body_btn.button_down.connect(
		func():
			_is_dragging = true
			_drag_start_position = get_local_mouse_position()
			_drag_start_position_global = get_global_mouse_position()
	)
	body_btn.button_up.connect(
		func():
			_is_dragging = false
			if (get_global_mouse_position() - _drag_start_position_global).length_squared() < 4:
				if btn_pressed: btn_pressed.call()
	)
	close_btn.pressed.connect(
		func():
			queue_free()
	)

func start():
	create_tween().set_loops().tween_callback(
		func():
			if get_widget_text:
				widget_label.text = get_widget_text.call()
	).set_delay(update_delay)
	if get_widget_text:
		widget_label.text = get_widget_text.call()

func _input(e):
	#release focus when you click outside of the window
	if e is InputEventMouseButton and e.pressed:
		if !get_global_rect().has_point(get_global_mouse_position()):
			var f = get_viewport().gui_get_focus_owner()
			if f and is_ancestor_of(f):
				f.release_focus()

func _process(delta):
	if _is_dragging:
		var tp = position + get_local_mouse_position() - _drag_start_position
		position = lerp(position, tp, 0.4)
	else:
		var window_rect = get_rect()
		var screen_rect = get_viewport_rect()
		var target_position = window_rect.position
		if window_rect.position.y < 0:
			target_position.y = 0
		if window_rect.end.y > screen_rect.end.y:
			target_position.y = screen_rect.end.y - window_rect.size.y
		if window_rect.position.x < 0:
			target_position.x = 0
		if window_rect.end.x > screen_rect.end.x:
			target_position.x = screen_rect.end.x - window_rect.size.x
		var current_position = window_rect.position
		current_position = lerp(current_position, target_position, 0.213)
		position = current_position

	if has_meta("info"):
		get_meta("info")["position"] = position
