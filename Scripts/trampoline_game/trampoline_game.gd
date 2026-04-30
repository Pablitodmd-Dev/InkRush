extends Node2D

signal finished(success: bool)

@onready var player = $Player
@onready var spawn_point = $SpawnPoint

var game_time: float = 7.0
var is_active: bool = true

func _ready():
	spawn_player_randomly()
	is_active = true

func _process(delta: float):
	$TimeLabel.text = str(int(game_time))
	if is_active:
		game_time -= delta
		
		if game_time <= 0:
			_on_victory()

func spawn_player_randomly():
	var random_range = 300.0
	var offset_x = randf_range(-random_range, random_range)
	
	player.global_position = Vector2(
		spawn_point.global_position.x + offset_x, 
		spawn_point.global_position.y
	)
	
	player.velocity = Vector2.ZERO

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
