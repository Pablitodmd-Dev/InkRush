extends CanvasLayer

# --- Pantallas principales ---
@onready var start_screen = $start    
@onready var victory_screen = $completed 
@onready var defeat_screen = $failed   
@onready var brush_container = $HBoxContainer
@onready var levelUp_screen = $levelUp 
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

# --- Sonidos ---
@onready var victory_sound = $VictorySound
@onready var defeat_sound = $DefeatSound
@onready var intermission_sound = $IntermissionSound

var total_score: int = 0

func _ready():
	hide_all()
	brush_container.show()
	update_score_display()
	
	# Animación constante para el marcador y el contenedor de vidas
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

func show_screen(screen_type: String):
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
			levelUp_screen.show()
			apply_pulse_animation(defeat_screen)
# --- Lógica de Animación Sutil (Pulse) ---

func apply_pulse_animation(node: CanvasItem):
	# Si es un nodo de UI (Control), centramos el pivote para que el latido sea parejo
	if node is Control:
		node.pivot_offset = node.size / 2
	
	# Si es un Sprite2D, asegúrate en el Inspector de que 'Centered' esté activado
	
	var tween = create_tween().set_loops()
	
	# Escala rítmica del 5% (1.05)
	tween.tween_property(node, "scale", Vector2(1.05, 1.05), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# --- Funciones de lógica ---

func increment_score():
	total_score += 1
	update_score_display()
	
	# Pequeño salto de impacto visual al ganar punto
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

func show_specific_controls(type: String):
	hide_all_controls()
	
	# Usamos CanvasItem para evitar errores entre Sprite2D y Control
	var selected_control: CanvasItem = null
	
	match type:
		"numbers": selected_control = controls_numbers
		"allArrows": selected_control = allArrows
		"horizontal": selected_control = horizontal_arrows
		"onlyup": selected_control = onlyup
		"onlyright": selected_control = onlyright
		"vertical": selected_control = vertical_arrows
	
	if selected_control:
		selected_control.show()
		apply_pulse_animation(selected_control) 
		
	if type != "none" and not intermission_sound.playing:
		intermission_sound.play()
