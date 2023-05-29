var _module:PankuModuleCheckLatestRelease

const _HELP_check = "Fetch latest release information from Github"
func check():
	_module.send_request().response_received.connect(
		func(msg:Dictionary):
			if !msg["success"]:
				_module.core.notify("[color=red][Error][/color] Failed! " + msg["msg"])
			else:
				_module.core.notify("[color=green][info][/color] Latest: [%s] [url=%s]%s[/url]" % [msg["published_at"], msg["html_url"], msg["name"]])
	)
