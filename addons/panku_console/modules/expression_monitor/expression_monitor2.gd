extends Control

@onready var monitor_groups_ui := $SmoothScrollContainer/HBoxContainer/Control/MonitorGroupsUI

var _module:PankuModule

func _physics_process(delta: float) -> void:
	if Engine.get_physics_frames() % 10 != 1:
		return
	if !is_visible_in_tree():
		return

	var exprss = monitor_groups_ui.get_expressions_by_group()
	var resultss = []
	for exprs in exprss:
		var results = []
		for expr in exprs:
			if expr == "":
				continue
			var eval_result_dict = _module.core.gd_exprenv.execute(expr)
			var eval_result:String = str(eval_result_dict["result"])
			results.append(eval_result)
		resultss.append(results)
	monitor_groups_ui.set_results_by_group(resultss)
