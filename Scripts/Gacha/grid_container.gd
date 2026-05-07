extends GridContainer

func unlock_by_index(index: int) -> void:
	if index < get_child_count():
		var slot = get_child(index)
		if slot.has_method("unlock"):
			slot.unlock()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gacha/main.tscn")
