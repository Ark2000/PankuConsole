var _os_report = preload("./os_report.gd").new()
var _core:PankuConsole

const _HELP_execute = "Display detailed OS report"
func execute() -> void:
	_core.output("Please wait, this may take a while...")
	await _core.get_tree().create_timer(0.1).timeout
	_os_report.inspect()
	var report =  "".join(_os_report.rtl)
	_core.output(report)
