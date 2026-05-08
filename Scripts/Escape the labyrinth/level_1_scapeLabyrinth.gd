extends Node2D
signal finished(success: bool)

@onready var timer = $Timer
@onready var countdown_sprite = $AnimatedSprite2D

func _ready():
	if Global.difficulty_level == 0:
		_ocultar_y_desactivar($Obstacles/Obstacle)
		_ocultar_y_desactivar($Obstacles/Obstacle2)
		_ocultar_y_desactivar($Obstacles/Obstacle3)
		_ocultar_y_desactivar($Obstacles/Obstacle4)

	elif Global.difficulty_level == 1:
		_ocultar_y_desactivar($Obstacles/Obstacle5)
		_ocultar_y_desactivar($Obstacles/Obstacle7)
		_ocultar_y_desactivar($Obstacles/Obstacle8)
	
	elif Global.difficulty_level == 2:
		_ocultar_y_desactivar($Obstacles/Obstacle3)
		_ocultar_y_desactivar($Obstacles/Obstacle4)
		_ocultar_y_desactivar($Obstacles/Obstacle6)
		_ocultar_y_desactivar($Obstacles/Obstacle7)
		_ocultar_y_desactivar($Obstacles/Obstacle8)

	timer.start()
	countdown_sprite.play("countdown")

func _ocultar_y_desactivar(obstaculo: Node2D):
	if obstaculo:
		obstaculo.hide()
		var col = obstaculo.get_node_or_null("CollisionShape2D")
		if col:
			col.set_deferred("disabled", true)

func _on_timer_timeout():
	print("¡Tiempo agotado! Cerrando juego...")
	finished.emit(false)
