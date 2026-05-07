extends Control

@onready var img_normal = $BackgroundNormal
@onready var img_victoria = $BackgroundVictory
@onready var endlessbuttonInactive = $EndlessMode
@onready var endlessbuttonactive = $EndlessModeInactive
@onready var sfx_player = $SFXPlayer 

func _ready():
	if Global.historia_completada:
		img_normal.hide()
		img_victoria.show()
		endlessbuttonactive.visible = false
		endlessbuttonInactive.visible = true
	else:
		img_normal.show()
		img_victoria.hide()
		endlessbuttonactive.visible = true
		endlessbuttonInactive.visible = false

func _on_pokeball_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		reproducir_efecto("res://Assets/Sounds/pokeball.wav")

func _on_eifet_tower_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		reproducir_efecto("res://Assets/Sounds/paris.wav")

func _on_mushroom_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		reproducir_efecto("res://Assets/Sounds/mushroom.wav")

func _on_car_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		reproducir_efecto("res://Assets/Sounds/Car.wav")

func _on_rubik_cube_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		reproducir_efecto("res://Assets/Sounds/Rubik Cube.wav")

func _on_kitchen_hat_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		reproducir_efecto("res://Assets/Sounds/chef.wav")

func reproducir_efecto(ruta_sonido: String):
	var clip = load(ruta_sonido)
	if clip: 
		sfx_player.stream = clip
		sfx_player.play()

func _on_story_mode_pressed() -> void:
	Global.endless_mode=false
	Global.difficulty_level = 0
	get_tree().change_scene_to_file("res://Scenes/Animations/History.tscn")


func _on_endless_mode_pressed() -> void:
	Global.endless_mode=true
	Global.difficulty_level = 0
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
