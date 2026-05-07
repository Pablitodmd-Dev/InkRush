extends Node2D



func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gacha/shelf.tscn")


func _on_texture_button_mouse_entered() -> void:
	$TextureButton.scale = Vector2(0.35, 0.35)


func _on_texture_button_mouse_exited() -> void:
	$TextureButton.scale = Vector2(0.3, 0.3)
