extends Control

@onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("intro")
	anim_player.animation_finished.connect(_on_intro_finished)

func _on_intro_finished(_anim_name):
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			_on_intro_finished("intro")
