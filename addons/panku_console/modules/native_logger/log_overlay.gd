extends RichTextLabel

var _module:PankuModuleNativeLogger

const CFG_OUTPUT_OVERLAY = "output_overlay"
const CFG_OUTPUT_OVERLAY_ALPHA = "output_overlay_alpha"
const CFG_OUTPUT_OVERLAY_FONT_SIZE = "output_overlay_font_size"
const CFG_OUTPUT_OVERLAY_FONT_SHADOW = "output_overlay_font_shadow"

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

func load_data():
	var cfg = _module.core.Config.get_config()
	visible = cfg.get(CFG_OUTPUT_OVERLAY, true)
	modulate.a = cfg.get(CFG_OUTPUT_OVERLAY_ALPHA, 0.5)
	theme.default_font_size= cfg.get(CFG_OUTPUT_OVERLAY_FONT_SIZE, 14)
	var shadow = cfg.get(CFG_OUTPUT_OVERLAY_FONT_SHADOW, false)
	set("theme_override_colors/font_shadow_color", Color.BLACK if shadow else null)

func save_data():
	var cfg = _module.core.Config.get_config()
	cfg[CFG_OUTPUT_OVERLAY] = visible
	cfg[CFG_OUTPUT_OVERLAY_ALPHA] = modulate.a
	cfg[CFG_OUTPUT_OVERLAY_FONT_SIZE] = theme.default_font_size
	cfg[CFG_OUTPUT_OVERLAY_FONT_SHADOW] = get("theme_override_colors/font_shadow_color") != null
	_module.core.Config.set_config(cfg)