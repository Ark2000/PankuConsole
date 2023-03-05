extends Node

func _ready():
	get_parent().register_env(name, self)
