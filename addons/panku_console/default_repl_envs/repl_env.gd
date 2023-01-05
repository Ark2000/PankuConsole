extends Node

func _ready():
	await get_parent().ready
	get_parent().register_env(name, self)
