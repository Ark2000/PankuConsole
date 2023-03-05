extends Control

@export var tag_btn:Button
@export var rm_btn:Button

var tag_text:String
var tag_number:int = 0

func check(message:String):
	if message.contains(tag_text):
		tag_number += 1
	tag_btn.text = "%s (%d)" % [tag_text, tag_number]
