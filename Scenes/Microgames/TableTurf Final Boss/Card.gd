extends Node2D

@export var card_data: CardData # Aquí arrastrarás tu Resource de carta

func _ready():
	if card_data:
		render_shape()

func render_shape():
	# Limpiamos si hubiera algo previo
	for child in get_children():
		child.queue_free()
	
	# Creamos un pequeño cuadrado por cada celda definida en los datos
	for cell in card_data.occupied_cells:
		var rect = ColorRect.new()
		rect.size = Vector2(30, 30) # Tamaño del cuadradito de la carta
		# Multiplicamos por 32 (o el tamaño que quieras) para separar las celdas
		rect.position = Vector2(cell.x * 32, cell.y * 32)
		rect.color = Color.SKY_BLUE # Color temporal
		add_child(rect)
