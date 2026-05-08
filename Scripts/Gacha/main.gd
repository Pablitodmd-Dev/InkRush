extends Node2D


func _process(_delta: float) -> void:
	# Accede a la variable de tu script global
	$CoinsLabel.text = "Coins: " + str(Global.coins)


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gacha/shelf.tscn")

func _on_texture_button_mouse_entered() -> void:
	$TextureButton.scale = Vector2(0.35, 0.35)


func _on_texture_button_mouse_exited() -> void:
	$TextureButton.scale = Vector2(0.3, 0.3)


func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_texture_button_2_mouse_entered() -> void:
	$TextureButton2.scale = Vector2(1.05,1.05)


func _on_texture_button_2_mouse_exited() -> void:
	$TextureButton2.scale = Vector2(1, 1)
