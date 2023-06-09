extends "./row_ui.gd"

@export var opt_btn:OptionButton

func update_ui(val):
	opt_btn.select(val)

func is_active():
	return opt_btn.has_focus()

func _ready():
	opt_btn.item_selected.connect(
		func(index:int):
			ui_val_changed.emit(index)
	)

func setup(params := []):
	opt_btn.clear()
	for p in params:
		opt_btn.add_item(p)
