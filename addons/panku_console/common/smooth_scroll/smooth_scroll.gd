extends PanelContainer

@export var clip_container:Control 

@export var scrollbar:VScrollBar

@export var follow_content:bool = true

@onready var content:Control = clip_container.get_child(0)

var scroll_progress:float = 0.0
var prev_content_size_y:float = 0.0

func init_progressbar() -> void:
	scrollbar.min_value = 0.0
	scrollbar.allow_greater = true
	scrollbar.allow_lesser = true
	scrollbar.value = 0.0

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		var step:float = clip_container.size.y / 8.0
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scrollbar.value -= step
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scrollbar.value += step

func _process(delta: float) -> void:
	# add a tiny optimization here
	if not is_visible_in_tree(): return
	
	# See https://github.com/Ark2000/PankuConsole/issues/183, looks quirky
	# content.size = Vector2(clip_container.size.x, 0)
	# content.position = Vector2.ZERO
	content.size.x = clip_container.size.x
	content.size.y = 0
	content.position.y = 0
	content.position.x = 0

	scrollbar.max_value = content.size.y
	var scrollbar_value_max = max(0, scrollbar.max_value - clip_container.size.y)
	scrollbar.value = PankuUtils.interp(scrollbar.value, clampf(scrollbar.value, 0.0, scrollbar_value_max), 10, delta)
	scrollbar.page = clip_container.size.y
	scrollbar.visible = content.size.y > clip_container.size.y

	scroll_progress = PankuUtils.interp(scroll_progress, scrollbar.value, 10, delta)
	content.position.y = - scroll_progress

	if !follow_content: return
	if prev_content_size_y != content.size.y:
		var should_follow:bool = (scrollbar.value + scrollbar.page) / prev_content_size_y > 0.99
		prev_content_size_y = content.size.y
		if should_follow:
			scrollbar.value = scrollbar.max_value - scrollbar.page

func _ready() -> void:
	init_progressbar()
