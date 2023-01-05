extends "res://addons/panku_console/default_repl_envs/repl_env.gd"

const _HELP_hints = "Get a random hint!"
var hints:
	get:
		var words = [
			"[color=orange]Thank you for using Panku Console![/color]",
			"[color=orange][Tip][/color]Type [b]help[/b] to learn more.",
			"[color=orange][Tip][/color]You can change the position of notifications in console.tscn"
		]
		words.shuffle()
		Console.notify(words[0])

const _HELP_cls = "Clear console logs"
var cls:
	get:
		(func():
			await get_tree().process_frame
			Console._console_ui.clear_output()
		).call()

const _HELP_enable_notifications = "Toggle notification system"
func enable_notifications(b:bool):
	Console._resident_logs.visible = b

const _HELP_notify = "Send a notification"
func notify(any):
	Console.notify(any)

const _HELP_check_update = "Fetch latest release info from Github"
var check_update:
	get: return Console._console_ui.check_latest_release()
