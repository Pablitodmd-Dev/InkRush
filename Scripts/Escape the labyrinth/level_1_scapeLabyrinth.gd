extends Node2D
signal finished(success: bool)

@onready var timer = $Timer
@onready var countdown_sprite = $AnimatedSprite2D

func _ready():
	timer.start()
	countdown_sprite.play("countdown")

func _on_timer_timeout():
	print("¡Tiempo agotado! Cerrando juego...")
	finished.emit(false)
