extends PankuConsole.ExporterRowUI

@export var slider:HSlider
@export var ledit:LineEdit

#Copied from the docs.

#Hints that an int or float property should be within a range specified via the hint string "min,max" or "min,max,step". The hint string can optionally include "or_greater" and/or "or_less" to allow manual input going respectively above the max or below the min values.
#
#Example: "-360,360,1,or_greater,or_less".
#
#Additionally, other keywords can be included: "exp" for exponential range editing, "radians" for editing radian angles in degrees, "degrees" to hint at an angle and "hide_slider" to hide the slider.

const properties = {
	"or_greater": "allow_greater",
	"or_less": "allow_lesser",
	"exp": "exp_edit",
#	"radians",
#	"degrees",
#	"hide_slider"
}

func setup(data_type:int, params := []):
	if params.size() >= 2:
		slider.min_value = params[0].to_float()
		slider.max_value = params[1].to_float()
	for i in range(2, params.size()):
		if i == 2 and !(params[2] in properties):
			slider.step = params[2].to_float()
			continue
		if params[i] in properties:
			slider.set(properties[params[i]], true)
			
	#set default step if not specified
	if params.size() == 2:
		if data_type == TYPE_INT:
			slider.step = 1
			slider.rounded = true
		elif data_type == TYPE_FLOAT:
			slider.step = (slider.max_value - slider.min_value) / 100.0

func _ready():
	
	ledit.text_submitted.connect(
		func(new_text): 
			ui_val_changed.emit(new_text)
			slider.value = new_text.to_float()
	)
	ledit.focus_exited.connect(
		func(): 
			ui_val_changed.emit(ledit.text)
			slider.value = ledit.text.to_float()
	)
	slider.value_changed.connect(
		func(val):
			ui_val_changed.emit(slider.value)
			ledit.text = str(val)
	)

func update_ui(val):
	ledit.text = str(val)
	slider.value = val

func is_active() -> bool:
	return ledit.has_focus()
