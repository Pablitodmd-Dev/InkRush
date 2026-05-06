extends TextureProgressBar

@export var fill_speed: float = 40.0 # Velocidad a la que se llena la barra
var moving: bool = true

func _process(delta):
	if not moving:
		return
	
	# Verificamos si la tecla "ui_up" está siendo presionada
	# (Asegúrate de que "ui_up" esté en tu Input Map o cambia el nombre)
	if Input.is_action_pressed("ui_up"):
		# Aumentamos el valor basado en el tiempo (delta)
		value += fill_speed * delta
	
	# clamp asegura que el valor nunca pase de 100 ni baje de 0
	value = clamp(value, 0, 100)

func get_power_quality() -> String:
	moving = false # Detenemos el movimiento al obtener la calidad
	if value > 40 and value < 60:
		return "green"
	elif value > 15 and value < 85:
		return "yellow"
	else:
		return "red"

func reset_bar():
	value = 0
	moving = true
