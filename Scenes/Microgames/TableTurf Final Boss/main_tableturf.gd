extends Node2D

@onready var board = $Board 
# --- IMPORTANTE: Revisa estas rutas si no aparecen los elementos ---
# Si en tu árbol de nodos están dentro de "PlayerUI" o "KromaUI", cámbialas aquí.
@onready var score_label = $UI/ScoreLabel 
@onready var hand_ui = $UI/HandUI 
@onready var pass_button = $UI/PassButton

func _ready():
	# 1. Conectar las señales primero
	board.score_updated.connect(_on_score_updated)
	board.hand_updated.connect(_on_hand_updated)
	pass_button.pressed.connect(board.pass_turn)
	
	# 2. Centrar el tablero
	center_board()

	# 3. FORZAR ACTUALIZACIÓN INICIAL
	# Llamamos a estas funciones para que el Board emita los datos 
	# ahora que Main ya está escuchando.
	board.update_score()
	_on_hand_updated(board.hero_hand, true)

func center_board():
	var board_size = Vector2(256, 256) 
	var viewport_size = get_viewport_rect().size
	board.position = (viewport_size / 2) - (board_size / 2)

func _on_score_updated(p1, p2, turn, max_turns):
	score_label.text = "Héroe: %d - %d Kroma\nTurno: %d / %d" % [p1, p2, turn, max_turns]

func _on_hand_updated(hand, is_player):
	# Limpiar botones anteriores
	for child in hand_ui.get_children():
		child.queue_free()
	
	# Crear botones para cada carta
	for i in range(hand.size()):
		var card = hand[i]
		var btn = Button.new()
		btn.text = card.resource_name if card.resource_name != "" else "Carta"
		btn.custom_minimum_size = Vector2(80, 40)
		btn.pressed.connect(func(): board.select_card_from_hand(i))
		hand_ui.add_child(btn)
