extends Node2D

signal score_updated(p1_score, p2_score, current_turn, max_turns)
signal hand_updated(hand_array, is_player)
signal turn_changed(is_player_turn)

enum Player { NONE = 0, P1 = 1, P2 = 2 }
var current_turn = Player.P1 
var is_player_turn: bool = true

var turn_counter = 0
const MAX_TURNS = 12 
const HERO_COLOR = Color.LIME_GREEN
const VILLAIN_COLOR = Color("#4B0082")
const BOARD_SIZE = Vector2i(8, 8)
const CELL_SIZE = 32

var grid_data = []
var cell_nodes = [] 
@export var all_cards: Array[Resource] 
var hero_deck = []
var kroma_deck = []
var hero_hand = []
var kroma_hand = []
var active_card = null 
var preview_cells = [] 

@onready var board_graphics = $BoardGraphics # Contenedor interno

func _ready():
	initialize_board()
	# Usamos call_deferred para asegurar que el nodo está listo antes de dibujar
	call_deferred("draw_board_visuals")
	
	hero_deck = all_cards.duplicate(); hero_deck.shuffle()
	kroma_deck = all_cards.duplicate(); kroma_deck.shuffle()
	
	for i in range(4):
		if hero_deck.size() > 0: hero_hand.append(hero_deck.pop_back())
		if kroma_deck.size() > 0: kroma_hand.append(kroma_deck.pop_back())
	
	update_score()
	emit_signal("hand_updated", hero_hand, true)

func pass_turn():
	# Si ya llegamos al máximo de turnos, no dejamos hacer nada más
	if turn_counter >= MAX_TURNS: return 
	if not is_player_turn: return 
	
	turn_counter += 1
	active_card = null
	clear_preview()
	
	if turn_counter >= MAX_TURNS: finish_game()
	else: switch_turn()

func update_score():
	var p1 = 0; var p2 = 0
	for x in range(BOARD_SIZE.x):
		for y in range(BOARD_SIZE.y):
			if grid_data[x][y] == Player.P1: p1 += 1
			elif grid_data[x][y] == Player.P2: p2 += 1
	
	# Usamos min para que el número no pase de 12
	var display_turn = min(turn_counter + 1, MAX_TURNS)
	emit_signal("score_updated", p1, p2, display_turn, MAX_TURNS)

func switch_turn():
	current_turn = Player.P2 if current_turn == Player.P1 else Player.P1
	is_player_turn = (current_turn == Player.P1)
	emit_signal("turn_changed", is_player_turn)
	if not is_player_turn: play_ai_turn()
	else: emit_signal("hand_updated", hero_hand, true)
	update_score()

func select_card_from_hand(index: int):
	if not is_player_turn: return 
	active_card = hero_hand[index]
	emit_signal("hand_updated", hero_hand, true)

func place_card(card_data, position: Vector2i):
	# Si ya llegamos al máximo de turnos, no dejamos colocar cartas
	if turn_counter >= MAX_TURNS: return 
	
	var player_color = HERO_COLOR if current_turn == Player.P1 else VILLAIN_COLOR
	for cell in card_data.occupied_cells:
		var target = position + cell
		grid_data[target.x][target.y] = current_turn
		var rect = cell_nodes[target.x][target.y]
		var tween = create_tween()
		tween.tween_property(rect, "color", player_color, 0.3)
	
	if current_turn == Player.P1:
		hero_hand.erase(card_data)
		if hero_deck.size() > 0: hero_hand.append(hero_deck.pop_back())
	else:
		kroma_hand.erase(card_data)
		if kroma_deck.size() > 0: kroma_hand.append(kroma_deck.pop_back())
	
	turn_counter += 1
	active_card = null 
	clear_preview()
	
	if turn_counter >= MAX_TURNS: finish_game()
	else: switch_turn()
	update_score()

# --- Lógica de Tablero ---
func initialize_board():
	grid_data = []; cell_nodes = []
	for x in range(BOARD_SIZE.x):
		var column = []; var node_column = []
		for y in range(BOARD_SIZE.y):
			column.append(0); node_column.append(null)
		grid_data.append(column); cell_nodes.append(node_column)
	
	# --- CORRECCIÓN DE POSICIONES INICIALES ---
	
	# Villano (P2, Morado) en Arriba-Izquierda (x=0, y=0)
	grid_data[0][0] = Player.P2
	
	# Héroe (P1, Verde) en Abajo-Derecha (x=7, y=7)
	grid_data[BOARD_SIZE.x - 1][BOARD_SIZE.y - 1] = Player.P1

func draw_board_visuals():
	for x in range(BOARD_SIZE.x):
		for y in range(BOARD_SIZE.y):
			var rect = ColorRect.new()
			rect.size = Vector2(CELL_SIZE - 2, CELL_SIZE - 2)
			rect.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
			
			var val = grid_data[x][y]
			if val == Player.P1:
				rect.color = HERO_COLOR
			elif val == Player.P2:
				rect.color = VILLAIN_COLOR
			else:
				rect.color = Color.DIM_GRAY
				
			board_graphics.add_child(rect)
			cell_nodes[x][y] = rect

# --- Input y Reglas ---
func _input(event):
	if not is_player_turn: return 
	var mouse_pos = get_local_mouse_position()
	var grid_pos = Vector2i(floor(mouse_pos.x / CELL_SIZE), floor(mouse_pos.y / CELL_SIZE))
	if active_card:
		update_preview(grid_pos)
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if is_inside_board(grid_pos) and can_place_card(active_card, grid_pos):
				place_card(active_card, grid_pos)

func update_preview(pos: Vector2i):
	clear_preview()
	var can_place = can_place_card(active_card, pos)
	var color = Color.WHITE if can_place else Color.RED
	color.a = 0.5
	for cell in active_card.occupied_cells:
		var target = pos + cell
		if is_inside_board(target):
			cell_nodes[target.x][target.y].color = color
			preview_cells.append(target)

func clear_preview():
	for pos in preview_cells:
		if is_inside_board(pos):
			var val = grid_data[pos.x][pos.y]
			cell_nodes[pos.x][pos.y].color = HERO_COLOR if val == Player.P1 else (VILLAIN_COLOR if val == Player.P2 else Color.DIM_GRAY)
	preview_cells.clear()

func can_place_card(card_data, position: Vector2i) -> bool:
	if card_data == null: return false
	var is_adjacent = false
	for cell in card_data.occupied_cells:
		var target = position + cell
		if not is_inside_board(target) or grid_data[target.x][target.y] != 0: return false
		if has_adjacent_ally(target, current_turn): is_adjacent = true
	return is_adjacent

func has_adjacent_ally(pos, player) -> bool:
	for n in [Vector2i(0,1), Vector2i(0,-1), Vector2i(1,0), Vector2i(-1,0)]:
		var check = pos + n
		if is_inside_board(check) and grid_data[check.x][check.y] == player: return true
	return false

func is_inside_board(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < BOARD_SIZE.x and pos.y >= 0 and pos.y < BOARD_SIZE.y

func play_ai_turn():
	await get_tree().create_timer(1.0).timeout 
	var possible_moves = []
	for card in kroma_hand:
		for x in range(BOARD_SIZE.x):
			for y in range(BOARD_SIZE.y):
				if can_place_card(card, Vector2i(x, y)):
					possible_moves.append({"card": card, "pos": Vector2i(x, y)})
	if possible_moves.size() > 0:
		var move = possible_moves.pick_random()
		active_card = move.card
		place_card(move.card, move.pos)
	else: switch_turn()

func finish_game():
	print("Partida finalizada")
