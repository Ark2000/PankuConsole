var _core:PankuConsole

const _HELP_help := "List all environment variables."
var help:String:
	get:
		var result = ["Registered objects:\n"]
		var colors = ["#7c3f58", "#eb6b6f", "#f9a875", "#fff6d3"]
		var i = 0
		for k in _core.gd_exprenv._envs:
			var c = colors[i%4]
			i = i + 1
			result.push_back("[b][color=%s]%s[/color][/b]  "%[c, k])
		result.push_back("\n")
		result.push_back("You can type [b]helpe(object)[/b] to get more information.")
		return "".join(PackedStringArray(result))

const _HELP_helpe := "Provide detailed information about one specific environment variable."
func helpe(obj:Object) -> String:
	if !obj:
		return "Invalid!"
	if !obj.get_script():
		return "It has no attached script!"
	return PankuGDExprEnv.generate_help_text_from_script(obj.get_script())
