extends Button

var title = "Fold Menu"

func _ready():

	var img = Image.new()
	img.copy_from(icon.get_image())
	img.flip_x()
	var unfold_icon = ImageTexture.create_from_image(img)
	var fold_icon = icon
	
	toggled.connect(
		func(button_pressed:bool):
			
			if button_pressed:
				icon = unfold_icon
			else:
				icon = fold_icon
				
			for node in get_parent().get_children():
				if not (node is Button):
					continue
				if button_pressed:
					node.text = " " + node.title + " "
				else:
					node.text = ""
	)
