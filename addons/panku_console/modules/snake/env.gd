var _module:PankuModule

const _HELP_execute = "Play Snake Game"
func play() -> void:
	_module.add_snake_window()

func leader_board() -> String:
	var content = ""
	content += "== Learder Board ==\n"
	content += str(_module.leader_board_arr)
	return content
