extends Control

@onready var img_normal = $BackgroundNormal
@onready var img_victoria = $BackgroundVictory

@onready var endlessbuttonInactive=$EndlessMode
@onready var endlessbuttonactive=$EndlessModeInactive
func _ready():
	if Global.historia_completada:
		img_normal.hide()
		img_victoria.show()
		endlessbuttonactive.visible=false
	else:
		img_normal.show()
		img_victoria.hide()
		endlessbuttonactive.visible=true
		endlessbuttonInactive.visible=false

func _on_boton_jugar_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_story_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
