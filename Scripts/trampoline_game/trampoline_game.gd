extends Node2D

signal finished(success: bool)
@onready var player = $Player
@onready var spawn_point = $SpawnPoint

func _ready():
	spawn_player_randomly()

func spawn_player_randomly():
	var random_range = 300.0
	var offset_x = randf_range(-random_range, random_range)
	
	player.global_position = Vector2(
		spawn_point.global_position.x + offset_x, 
		spawn_point.global_position.y
	)
	
	player.velocity = Vector2.ZERO


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Game Over")
		body.set_physics_process(false)
		body.modulate = Color.RED
		await get_tree().create_timer(1.0).timeout
		finished.emit(false)
