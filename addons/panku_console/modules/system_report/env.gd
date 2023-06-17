var _os_report = preload("./os_report.gd").new()
var _module:PankuModule

const _HELP_execute = "Display detailed OS report"
func execute() -> void:
	_module.core.notify("Please wait, this may take a while...")
	await _module.core.get_tree().create_timer(0.1).timeout
	_os_report.inspect()
	var report =  "".join(_os_report.rtl)
	# _module.core.output(report)
