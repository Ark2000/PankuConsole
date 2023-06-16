extends Resource

@export_group("check_latest_release")

var _module:PankuModule

@export var export_button_check_update := "Check Update"

func check_update():
    _module.check()
