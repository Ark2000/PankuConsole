#This script will always be loaded first.
#You can add your own methods or variables to play around.

extends Node

const help = "available methods: say_hi(), enable_in_game_logs(bool), cls()"

func say_hi():
	return "[color=blue][b]Hello world![/b][/color]"

#by default, resident logs is disabled, you can enable it.
func enable_in_game_logs(b:bool):
	get_parent()._resident_logs.visible = b

func cls():
	_clear_logs()

func _clear_logs():
	await get_tree().process_frame
	get_parent()._console_logs.clear()
