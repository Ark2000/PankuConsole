extends Control

var _module:PankuModule

@onready var intro := $SmoothScrollContainer/HBoxContainer/Control/VBoxContainer/Label
@onready var project_page_button := $SmoothScrollContainer/HBoxContainer/Control/VBoxContainer/HBoxContainer/Button
@onready var check_update_button := $SmoothScrollContainer/HBoxContainer/Control/VBoxContainer/HBoxContainer/Button2

# Called when the node enters the scene tree for the first time.
func _ready():
	intro.text += "Version: " + PankuUtils.get_plugin_version() + "\n"
	var sha = PankuUtils.get_commit_sha_short()
	intro.text += "Commit: " + (sha if sha != "" else "Unknown") + "\n"
	intro.text += "Godot Engine: " + Engine.get_version_info().string + "\n"

	intro.text += "\nPanku Console is a community driven project under MIT license, thanks to everyone who have contributed to this project:\n"
	intro.text += "(Contact me if you don't see your name)\n\n"
	intro.text += "Ark2000 (Feo Wu)\n"
	intro.text += "scriptsengineer (Rafael Correa)\n"
	intro.text += "mieldepoche\n"
	intro.text += "Eggbertx\n"
	intro.text += "univeous\n"
	intro.text += "CheapMeow\n"
	intro.text += "winston-yallow (Winston)\n"

	project_page_button.pressed.connect(
		func():
			OS.shell_open("https://github.com/Ark2000/PankuConsole")
	)
	
	check_update_button.pressed.connect(
		func():
			_module.core.gd_exprenv.execute("check_latest_release.check()")
	)
