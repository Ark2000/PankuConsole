class_name PankuModuleTextureViewer extends PankuModule

const texture_viewer_prefab = preload("./texture_viewer.tscn")

func init_module():
	core.new_expression_entered.connect(
		func(exp:String, result):
			if !result["failed"] and result["result"] is Texture2D:
				add_texture_viewer_window(exp)
	)

func add_texture_viewer_window(expr:String):
	#print("add_texture_viewer_window(%s)"%expr)
	var texture_viewer := texture_viewer_prefab.instantiate()
	texture_viewer.expr = expr
	texture_viewer._module = self
	var window:PankuLynxWindow = core.windows_manager.create_window(texture_viewer)
	window.queue_free_on_close = true
	window.set_window_title_text("Texture: " + expr)
	window.centered()
	window.move_to_front()
