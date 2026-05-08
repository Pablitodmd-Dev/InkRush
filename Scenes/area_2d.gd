extends Area2D


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not Global.coin_pressed:
			coins()

func coins():
	Global.coin_pressed = true
	Global.coins += 1
	print("se suma moneda? ", Global.coins)
