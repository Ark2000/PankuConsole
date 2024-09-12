extends PanelContainer

@onready var label := $Label

# Basic Settings
var expression_string:String = ""
var update_interval:float = 0.5

# position
var base_position_formula:Array = ["(w1-w2)/2", "(h1-h2)/2"]
var offset_position:Vector2 = Vector2.ZERO

# Runtime variable
var remaining_time:float = update_interval

func get_base_position() -> Vector2:
	var bpos = Vector2.ZERO
	var w1 = get_viewport_rect().size.x
	var h1 = get_viewport_rect().size.y
	var w2 = size.x
	var h2 = size.y
	var exp = Expression.new()
	var input_names = ["w1", "w2", "h1", "h2"]
	var input_values = [w1, w2, h1, h2]
	if OK == exp.parse(base_position_formula[0], input_names):
		var result = exp.execute(input_values, null, false)
		if not exp.has_execute_failed():
			bpos.x = result
	if OK == exp.parse(base_position_formula[1], input_names):
		var result = exp.execute(input_values, null, false)
		if not exp.has_execute_failed():
			bpos.y = result
	return bpos

func get_final_position() -> Vector2:
	return get_base_position() + offset_position

func update_position():
	position = get_final_position()

func set_label_text(text:String):
	label.text = text

func get_style_box() -> StyleBoxFlat:
	return get("theme_override_styles/panel")

# serialization

func get_dict() -> Dictionary:
	return {
		"expression_string": expression_string,
		"update_interval": update_interval,
		"base_position_formula": base_position_formula,
		"offset_position": offset_position,
		"background_color": get_style_box().bg_color,
		"text_color": label.modulate,
		"font_size": label.label_settings.font_size
	}

func load_dict(data:Dictionary):
	expression_string = data.expression_string
	update_interval = data.update_interval
	get_style_box().bg_color = data.background_color
	label.modulate = data.text_color
	label.label_settings.font_size = data.font_size

	base_position_formula = data.base_position_formula
	offset_position = data.offset_position
