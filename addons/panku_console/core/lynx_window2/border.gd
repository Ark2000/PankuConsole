extends Panel

func hey_i_am_here():
	modulate.a = 0.0
	var t = create_tween()
	for i in range(2):
		t.tween_property(self, "modulate:a", 1.0, 0.1)
		t.tween_property(self, "modulate:a", 0.0, 0.1)
