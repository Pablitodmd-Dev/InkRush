extends Control

signal card_clicked(index)

var index_in_hand: int = 0
@export var card_data: CardData

func _ready():
	self.custom_minimum_size = Vector2(100, 100)
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	update_visuals()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		card_clicked.emit(index_in_hand)

func update_visuals():
	for child in get_children():
		child.queue_free()

	if not card_data:
		return

	var img = TextureRect.new()
	img.texture = card_data.card_texture
	img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	img.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(img)
