extends TextureRect

@export var item_id: String
@export var item_texture: Texture2D

func _ready():
	if item_texture:
		self.texture = item_texture
	update_appearance()

func update_appearance():
	if Global.collection.get(item_id, false):
		self.modulate = Color(1, 1, 1) # Visible
	else:
		self.modulate = Color(0.5, 0.5, 0.5) # Silhouette
