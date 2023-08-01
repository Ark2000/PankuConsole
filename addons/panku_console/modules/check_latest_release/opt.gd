extends ModuleOptions

@export_group("check_latest_release")

@export var export_button_check_update := "Check Update"

func check_update():
	_module.check()
