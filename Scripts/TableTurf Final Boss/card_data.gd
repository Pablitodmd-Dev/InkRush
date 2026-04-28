extends Resource
class_name CardData

@export var name: String = "Nombre de la carta"
@export var power: int = 1

# Aquí está el secreto:
# Solo definimos las celdas que están "activas" (llenas).
# Por ejemplo, una carta en forma de L pequeña:
# [Vector2i(0,0), Vector2i(0,1), Vector2i(1,1)]
@export var occupied_cells: Array[Vector2i] = [] 

# Para que el juego sepa qué tan grande es el "contenedor" de esta carta
@export var grid_size: Vector2i = Vector2i(6, 6)
