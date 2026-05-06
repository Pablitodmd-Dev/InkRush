extends Control 

func _ready() -> void:
	$AnimationPlayer.play("intro")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro": 
		get_tree().change_scene_to_file("res://Scenes//Main.tscn")
