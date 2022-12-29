extends Node

func _ready():
	await get_parent().ready
	get_parent().register_env(name, self)

const _HELP_hints = "Get a random hint!"
var hints:
	get:
		var words = [
			"[color=orange]Thank you for using Panku Console![/color]",
			"[color=orange][Tip][/color]Type [b]help[/b] to learn more.",
			"[color=orange][Tip][/color]You can change the position of notifications in console.tscn"
		]
		words.shuffle()
		get_parent().notify(words[0])

const _HELP_cls = "Clear console logs"
var cls:
	get:
		(func():
			await get_tree().process_frame
			get_parent()._console_ui.clear_output()
		).call()

const _HELP_enable_notifications = "Toggle notification system"
func enable_notifications(b:bool):
	get_parent()._resident_logs.visible = b

const _HELP_notify = "Send a notification"
func notify(any):
	get_parent().notify(any)
