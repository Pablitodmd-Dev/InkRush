extends CanvasLayer

# --- Pantallas principales ---
@onready var start_screen = $start    
@onready var victory_screen = $completed 
@onready var defeat_screen = $failed   
@onready var brush_container = $HBoxContainer
@onready var levelUp_screen = $levelUp 
@onready var pause_menu = $pauseMenu
# --- Elementos de Texto ---
@onready var score_counter_label = $ScoreCounter
@onready var game_name_label = $GameNameLabel

# --- Controles ---
@onready var controls_numbers = $numbers
@onready var horizontal_arrows = $horizontalArrows
@onready var vertical_arrows = $verticalArrows
@onready var onlyup = $onlyUp
@onready var onlyright = $onlyRight
@onready var allArrows = $allArrows
@onready var mouse = $mouse

# --- Sonidos ---
@onready var victory_sound = $VictorySound
@onready var defeat_sound = $DefeatSound
@onready var intermission_sound = $IntermissionSound

var total_score: int = 0
var is_leveling_up: bool = false # Control para evitar errores de animación

func _ready():
	hide_all()
	brush_container.show()
	update_score_display()
	
	apply_pulse_animation(score_counter_label)
	apply_pulse_animation(brush_container)

func hide_all():
	start_screen.hide()
	victory_screen.hide()
	defeat_screen.hide()
	brush_container.hide()
	score_counter_label.hide() 
	game_name_label.hide()
	levelUp_screen.hide()
	
func abrir_pausa():
	get_tree().paused = true
	pause_menu.show()

func show_screen(screen_type: String):
	# Si es levelup, NO ocultamos todo para que el fondo (start) se mantenga
	if screen_type != "levelup":
		hide_all() 
	
	brush_container.show()
	score_counter_label.show() 
	
	match screen_type:
		"start":
			start_screen.show()
			game_name_label.show()
			apply_pulse_animation(game_name_label) 
			intermission_sound.play()
		"completed":
			victory_screen.show()
			apply_pulse_animation(victory_screen)
			victory_sound.play()
		"failed":
			defeat_screen.show()
			apply_pulse_animation(defeat_screen)
			defeat_sound.play()
		"levelup":
			if is_leveling_up: return 
			
			is_leveling_up = true
			start_screen.show()
			levelUp_screen.show()
			apply_pulse_animation(levelUp_screen)
			
			await get_tree().create_timer(5.0).timeout
			levelUp_screen.hide()
			is_leveling_up = false

# --- Lógica de Animación ---

func apply_pulse_animation(node: CanvasItem):
	if node is Control:
		node.pivot_offset = node.size / 2
	
	var tween = create_tween().set_loops()
	tween.tween_property(node, "scale", Vector2(1.05, 1.05), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# --- Funciones de lógica ---

func increment_score():
	total_score += 1
	update_score_display()
	print(total_score)
	print(Global.difficulty_level)
	# 1. Evaluamos primero el nivel más alto.
	# Si llegamos a 20 y todavía estamos en nivel 1, subimos al 2.
	if total_score >= 20 and Global.difficulty_level < 2:
		Global.difficulty_level = 2
		show_screen("levelup")
	
	# 2. Si no es nivel 20, evaluamos el nivel 10.
	# Usamos un 'elif' para que no intente ejecutar ambos en el mismo frame.
	elif total_score >= 10 and Global.difficulty_level < 1:
		Global.difficulty_level = 1
		show_screen("levelup")
	
	# Animación de punch
	var punch = create_tween()
	punch.tween_property(score_counter_label, "scale", Vector2(1.3, 1.3), 0.1)
	punch.tween_property(score_counter_label, "scale", Vector2(1.0, 1.0), 0.1)

func update_score_display():
	score_counter_label.text = "%02d" % total_score

func set_game_name(text: String):
	game_name_label.text = text

func update_brushes(lives_left: int):
	brush_container.show()
	var brushes = brush_container.get_children() 
	for i in range(brushes.size()):
		brushes[i].visible = i < lives_left
		
func hide_all_controls():
	controls_numbers.hide()
	horizontal_arrows.hide()
	vertical_arrows.hide()
	onlyup.hide()
	allArrows.hide()
	onlyright.hide()
	mouse.hide()

func show_specific_controls(type: String):
	hide_all_controls()
	var selected_control: CanvasItem = null
	match type:
		"numbers": selected_control = controls_numbers
		"allArrows": selected_control = allArrows
		"horizontal": selected_control = horizontal_arrows
		"onlyup": selected_control = onlyup
		"onlyright": selected_control = onlyright
		"vertical": selected_control = vertical_arrows
		"mouse": selected_control = mouse
	
	if selected_control:
		selected_control.show()
		apply_pulse_animation(selected_control) 
		
	if type != "none" and not intermission_sound.playing:
		intermission_sound.play()

func _on_pause_controls_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.hide()

func _on_pause_controls_exit_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
