extends Node2D

@onready var board = $Board 
@onready var round_label = $UI/RoundLabel
@onready var player_score_label = $UI/PlayerScoreLabel
@onready var kroma_score_label = $UI/KromaScoreLabel
@onready var hand_ui = $UI/HandUI 
@onready var pass_button = $UI/PassButton

var card_scene = preload("res://Scenes/Microgames/TableTurf Final Boss/Card.tscn")

func _ready():
	hand_ui.add_theme_constant_override("separation", 0)
	board.score_updated.connect(_on_score_updated)
	board.hand_updated.connect(_on_hand_updated)
	pass_button.pressed.connect(board.pass_turn)
	
	center_board()
	board.update_score()
	_on_hand_updated(board.hero_hand, true)

func center_board():
	var board_size = Vector2(256, 256) 
	var viewport_size = get_viewport_rect().size
	board.position = (viewport_size / 2) - (board_size / 2)

func _on_score_updated(p1, p2, turn, max_turns):
	round_label.text = "%d / %d" % [turn, max_turns]
	player_score_label.text = str(p1)
	kroma_score_label.text = str(p2)

func _on_hand_updated(hand, is_player):
	for child in hand_ui.get_children():
		child.queue_free()
	
	for i in range(hand.size()):
		var card_data = hand[i]
		if card_data == null: continue
		
		var card_instance = card_scene.instantiate()
		card_instance.card_data = card_data
		card_instance.index_in_hand = i
		card_instance.card_clicked.connect(board.select_card_from_hand)
		
		hand_ui.add_child(card_instance)
