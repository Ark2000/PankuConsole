extends RichTextLabel

var _module:PankuModule

const MAX_LENGTH = 65536
var last_line := "34167be221cebca8dce11e47d86b82d017d7cd57"
var duplicated_counter := 1
var content_prev := ""
var content_cur := ""

func add_line(line:String):
	if content_cur.length() > MAX_LENGTH:
		content_cur = ""
		content_prev = ""
	
	if line == last_line:
		duplicated_counter += 1
	else:
		last_line = line
		duplicated_counter = 1

	if duplicated_counter > 1:
		var new_line = "[b](%d)[/b] %s" % [duplicated_counter, line]
		text = content_prev + new_line + "\n"
		content_cur = text
	else:
		content_prev = content_cur
		content_cur += (line + "\n")
		text = content_cur
