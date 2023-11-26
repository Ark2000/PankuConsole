extends VBoxContainer

# it is like, an infinite scroll game.

# specifically, the first buffer will be cleared and sent to the last
# when the last buffer is full.

# with buffers, we can constanly output lots of fancy stuff while keeping a smooth experience.

const BUFFER_MAX_PARAGRAPHS = 64
const BUFFERS = 4

var cur_label_idx:int = 0

func add_text(text:String):
	var cur_label:RichTextLabel = get_child(cur_label_idx)
	cur_label.text += text
	if cur_label.get_paragraph_count() > BUFFER_MAX_PARAGRAPHS:
		cur_label_idx += 1
		if cur_label_idx == BUFFERS:
			cur_label_idx = BUFFERS - 1
			var first_label:RichTextLabel = get_child(0)
			first_label.text = ""
			move_child(first_label, BUFFERS - 1)

func _ready():
	set("theme_override_constants/separation", 0)
	for child in get_children():
		child.queue_free()
	for i in range(BUFFERS):
		var new_buffer:RichTextLabel = RichTextLabel.new()
		new_buffer.fit_content = true
		new_buffer.bbcode_enabled = true
		new_buffer.selection_enabled = true
		add_child(new_buffer)
