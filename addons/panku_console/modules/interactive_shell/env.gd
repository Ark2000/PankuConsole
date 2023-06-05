var _module:PankuModuleInteractiveShell

func open_shell():
	_module.window.move_to_front()
	_module.window.show()

func open_launcher():
	_module.simple_launcher.show()
