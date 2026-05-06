extends AnimatableBody2D

# Configura estas posiciones en el Inspector (arrastra tus Marker2D aquí)
@export var pos_a: Vector2 
@export var pos_b: Vector2 

# Referencia al área que detecta si el jugador está encima
@onready var detection_area = $DetectionArea

func _input(event):
	# Si pulsas Arriba, vamos a pos_b (Arriba)
	if event.is_action_pressed("ui_up"):
		teletransportar(pos_b)
		
	# Si pulsas Abajo, vamos a pos_a (Abajo)
	elif event.is_action_pressed("ui_down"):
		teletransportar(pos_a)

func teletransportar(target_pos):
	# 1. Calculamos la diferencia de posición
	var offset = target_pos - global_position
	
	# 2. Movemos la plataforma instantáneamente
	global_position = target_pos
	
	# 3. Movemos al jugador en el siguiente frame de físicas
	call_deferred("mover_jugador", offset)

func mover_jugador(offset):
	for body in detection_area.get_overlapping_bodies():
		if body is CharacterBody2D:
			# 1. Reseteamos la velocidad ANTES de moverlo para borrar cualquier inercia
			body.velocity = Vector2.ZERO
			
			# 2. Movemos al personaje
			body.global_position += offset
			
			# 3. Forzamos una actualización de las colisiones inmediatamente
			# Esto evita que el motor se "confunda" en el siguiente frame
			body.move_and_slide()
