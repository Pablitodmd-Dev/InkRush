extends Control 

func _ready() -> void:
	$AnimationPlayer.play("intro")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Global.intro_visto:
			_iniciar_transicion_final()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "intro": 
		Global.intro_visto = true
		_iniciar_transicion_final()
	elif anim_name == "starting_game":
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _iniciar_transicion_final() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("starting_game")
