extends Control

var _module:PankuModule

@export var intro:Label
@export var project_page_button:Button
@export var check_update_button:Button

# Called when the node enters the scene tree for the first time.
func _ready():
	var version:String = PankuUtils.get_plugin_version()
	var sha:String = PankuUtils.get_commit_sha_short()
	if sha == "": sha = "Unknown"

	intro.text = intro.text.replace("<version>", version)
	intro.text = intro.text.replace("<commit>", sha)

	project_page_button.pressed.connect(
		func():
			OS.shell_open("https://github.com/Ark2000/PankuConsole")
	)
	
	check_update_button.pressed.connect(
		func():
			_module.core.gd_exprenv.execute("check_latest_release.check()")
	)
