extends Resource
class_name CardData

@export var name: String = "Card Name"
@export var power: int = 1
@export var card_texture: Texture2D
@export var occupied_cells: Array[Vector2i] = [] 
@export var grid_size: Vector2i = Vector2i(6, 6)
