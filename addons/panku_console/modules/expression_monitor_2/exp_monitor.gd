extends Button

const SERIALIZABLE_PROPERTIES = [
	["expression_string", ""],
	["update_interval", 0.5],
	["base_position_formula_x", "w1-w2"],
	["base_position_formula_y", "0"],
	["offset_position", Vector2.ZERO],
	["background_color", Color(0.1, 0.1, 0.1, 0.5)],
	["font_color", Color(1, 1, 1)],
	["font_size", 12],
	["enabled", true],
	["clickable", false],
	["click_expression", ""]
]

@onready var button:Button = $Button

# Basic Settings
@export var expression_string:String:
	set(v):
		expression_string = v
		# reset the remaining time to update the expression result immediately
		remaining_time = 0.0

@export_range(0.1, 2.0, 0.1) var update_interval:float

@export var enabled:bool = true

@export var readonly_last_eval_result:String:
	get:
		return last_eval_result

@export var readonly_status:String:
	get:
		if enabled:
			if error_flag and expression_string == error_exp:
				return "Invalid Expression"
			return "Running, refresh in %.2f seconds" % [remaining_time]
		else:
			return "Stopped"

@export var clickable:bool:
	set(v):
		clickable = v
		if clickable:
			button.mouse_filter = MOUSE_FILTER_STOP
		else:
			button.mouse_filter = MOUSE_FILTER_IGNORE
@export var click_expression:String = ""

# position
@export var export_comment_base_position_help = "About base position: w1, h1 are the size of the viewport, w2, h2 are the size of the monitor widget."
@export var base_position_formula_x:String
@export var base_position_formula_y:String
@export var offset_position:Vector2 = Vector2.ZERO:
	set(v):
		offset_position = v
		update_position()

@export var export_button_preset_topleft := "Preset: Top Left"
func preset_topleft():
	base_position_formula_x = "0"
	base_position_formula_y = "0"
	offset_position = Vector2.ZERO

@export var export_button_preset_center_top := "Preset: Top Right"
func preset_center_top():
	base_position_formula_x = "w1-w2"
	base_position_formula_y = "0"
	offset_position = Vector2.ZERO

@export var export_button_preset_center := "Preset: Center"
func preset_center():
	base_position_formula_x = "(w1-w2)/2"
	base_position_formula_y = "(h1-h2)/2"
	offset_position = Vector2.ZERO

@export var export_button_preset_bottomright := "Preset: Bottom Right"
func preset_bottomright():
	base_position_formula_x = "w1-w2"
	base_position_formula_y = "h1-h2"
	offset_position = Vector2.ZERO

@export var export_button_preset_bottomleft := "Preset: Bottom Left"
func preset_bottomleft():
	base_position_formula_x = "0"
	base_position_formula_y = "h1-h2"
	offset_position = Vector2.ZERO


# Style

@export var font_size:int:
	set(v):
		set("theme_override_font_sizes/font_size", v)
	get:
		return get("theme_override_font_sizes/font_size")

@export var font_color:Color:
	set(v):
		set("theme_override_colors/font_color", v)
	get:
		return get("theme_override_colors/font_color")

@export var background_color:Color:
	set(v):
		get("theme_override_styles/normal").bg_color = v
	get:
		return get("theme_override_styles/normal").bg_color

# Runtime variable
var remaining_time:float = update_interval
var error_exp:String = ""
var error_flag:bool = false
var last_eval_result:String = ""
var gdexprenv:PankuGDExprEnv

func set_eval_env(env:PankuGDExprEnv):
	gdexprenv = env

func get_base_position() -> Vector2:
	var bpos = Vector2.ZERO
	var w1 = get_viewport_rect().size.x
	var h1 = get_viewport_rect().size.y
	var w2 = size.x
	var h2 = size.y
	var exp = Expression.new()
	var input_names = ["w1", "w2", "h1", "h2"]
	var input_values = [w1, w2, h1, h2]
	# TODO: optimize this
	if OK == exp.parse(base_position_formula_x, input_names):
		var result = exp.execute(input_values, null, false)
		if not exp.has_execute_failed():
			bpos.x = result
	if OK == exp.parse(base_position_formula_y, input_names):
		var result = exp.execute(input_values, null, false)
		if not exp.has_execute_failed():
			bpos.y = result
	return bpos

func get_final_position() -> Vector2:
	return get_base_position() + offset_position

func update_position():
	position = get_final_position()

func set_label_text(text_:String):
	text = text_

func update_monitor(delta:float):
	if not enabled: return
	# the expression will not be evaluated if it is the same as the last failed one
	if error_flag and expression_string == error_exp: return
	remaining_time -= delta
	if remaining_time > 0: return
	
	remaining_time = update_interval
	var eval_result_dict:Dictionary = gdexprenv.execute(expression_string)
	var eval_result:String = str(eval_result_dict["result"])
	last_eval_result = eval_result
	error_flag = eval_result_dict["failed"]
	if error_flag: error_exp = expression_string
	set_label_text(eval_result)
	size = get_minimum_size()
	update_position()

func _ready():
	button.pressed.connect(
		func():
			if not clickable: return
			gdexprenv.execute(click_expression)
	)

# serialization

func save() -> Dictionary:
	return PankuUtils.serialize_simple_object(self)

func load(data:Dictionary):
	PankuUtils.deserialize_simple_object(self, data)
