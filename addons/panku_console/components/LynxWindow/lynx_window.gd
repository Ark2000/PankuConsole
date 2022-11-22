extends ColorRect

@onready var title_btn:Button = $Title
@onready var resize_btn:Button = $ResizeButton
@onready var exit_btn:Button = $Title/ExitButton

var _is_dragging := false
var _drag_start_position:Vector2
var _is_resizing := false
var _resize_start_position:Vector2

var is_visible := false:
	set(v):
		is_visible = v
		visible = is_visible

func _ready():
	title_btn.button_down.connect(
		func():
			_is_dragging = true
			_drag_start_position = get_local_mouse_position()
	)
	title_btn.button_up.connect(
		func():
			_is_dragging = false
	)
	resize_btn.button_down.connect(
		func():
			_is_resizing = true
			_resize_start_position = resize_btn.get_local_mouse_position()
	)
	resize_btn.button_up.connect(
		func():
			_is_resizing = false
	)
	exit_btn.pressed.connect(
		func():
			self.is_visible = false
	)
	is_visible = visible

func _input(e):
	#release focus when you click outside of the window
	if is_visible:
		if e is InputEventMouseButton and e.pressed:
			if !get_global_rect().has_point(get_global_mouse_position()):
				var f = get_viewport().gui_get_focus_owner()
				if f and is_ancestor_of(f):
					f.release_focus()
		if e is InputEventKey and e.keycode == KEY_ESCAPE and e.pressed and get_global_rect().has_point(get_global_mouse_position()):
			self.is_visible = false

func _process(delta):
	if _is_dragging:
		var tp = position + get_local_mouse_position() - _drag_start_position
		position = lerp(position, tp, 0.4)
	elif _is_resizing:
		var ts = size + resize_btn.get_local_mouse_position() - _resize_start_position
		ts.x = min(ts.x, get_viewport_rect().size.x)
		ts.y = min(ts.y, get_viewport_rect().size.y)
		size = lerp(size, ts, 0.4)
	else:
		var window_rect = get_rect()
		var screen_rect = get_viewport_rect()
		var target_position = window_rect.position
		if window_rect.position.y < 0:
			target_position.y = 0
		if window_rect.end.y > screen_rect.end.y:
			target_position.y = screen_rect.end.y - window_rect.size.y
		if window_rect.end.y > screen_rect.end.y + window_rect.size.y / 2:
			target_position.y = screen_rect.end.y - 25
		if window_rect.position.x < 0:
			target_position.x = 0
		if window_rect.end.x > screen_rect.end.x:
			target_position.x = screen_rect.end.x - window_rect.size.x
		var current_position = window_rect.position
		current_position = lerp(current_position, target_position, 0.213)
		position = current_position
