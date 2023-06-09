extends HBoxContainer

var name_label:Label:
	get: return get_node("VName")

signal ui_val_changed(val)

func get_ui_val():
	return null

func update_ui(val):
	pass

#stop sync if is active(eg. a line edit node is in focus)
func is_active() -> bool:
	return false
