extends PanelContainer

@export var clip_container:Control 

@export var scrollbar:VScrollBar

@onready var content:Control = clip_container.get_child(0)

var scroll_progress:float = 0.0

func init_progressbar() -> void:
	scrollbar.min_value = 0.0
	scrollbar.allow_greater = true
	scrollbar.allow_lesser = true
	scrollbar.value = 0.0

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			scrollbar.value -= clip_container.size.y / 8.0
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scrollbar.value += clip_container.size.y / 8.0

func _process(delta: float) -> void:
	content.size.y = 0
	scrollbar.max_value = content.size.y
	scrollbar.value = lerp(scrollbar.value, clampf(scrollbar.value, 0.0, scrollbar.max_value - clip_container.size.y), 0.2)
	scrollbar.page = clip_container.size.y
	scrollbar.visible = content.size.y > clip_container.size.y

	scroll_progress = lerp(scroll_progress, scrollbar.value, 0.2)
	content.position.y = - scroll_progress

func _ready() -> void:
	init_progressbar()
