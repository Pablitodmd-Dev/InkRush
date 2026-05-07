extends Node2D

signal finished(success: bool)

@onready var player = $Player
@onready var spawn_point = $SpawnPoint

var is_active: bool = true

@onready var timer = $Timer
@onready var countdown_sprite = $AnimatedSprite2D

func _ready():
	is_active = true
	timer.start()
	countdown_sprite.play("countdown")

func _on_timer_timeout():
	
	print("¡Tiempo agotado! Cerrando juego...")
	_on_victory()

func _on_victory():
	is_active = false
	print("Time's up! You survived.")
	player.set_physics_process(false)
	finished.emit(true)

func _on_death_zone_body_entered(body: Node2D) -> void:
	if is_active and body is CharacterBody2D:
		is_active = false
		print("Game Over")
		body.set_physics_process(false)
		body.modulate = Color.RED
		
		await get_tree().create_timer(1.0).timeout
		finished.emit(false)
