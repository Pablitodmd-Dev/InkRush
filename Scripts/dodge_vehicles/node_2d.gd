extends Node2D

const CAR_OBSTACLE_SCENE = preload("res://Scenes/Microgames/dodge_vehicles/car_obstacle.tscn")

@export var road_speed: float = 400.0
@export var min_spawn_x: float = 111.0
@export var max_spawn_x: float = 1070.0
@export var safe_distance: float = 120.0

func _process(delta):
	$ParallaxBackground.scroll_offset.y += road_speed * delta

func _on_car_spawn_timer_timeout() -> void:
	var spawn_x = -1.0
	var attempts = 0
	
	while attempts < 5:
		var potential_x = randf_range(min_spawn_x, max_spawn_x)
		if is_position_safe(potential_x):
			spawn_x = potential_x
			break
		attempts += 1
	
	if spawn_x != -1.0:
		spawn_car(spawn_x)

func is_position_safe(x_to_check: float) -> bool:
	var current_cars = get_tree().get_nodes_in_group("enemies")
	
	for car in current_cars:
		if car.global_position.y < 150:
			if abs(car.global_position.x - x_to_check) < safe_distance:
				return false
	return true

func spawn_car(x_pos: float):
	var car = CAR_OBSTACLE_SCENE.instantiate()
	car.global_position = Vector2(x_pos, $SpawnPointY.global_position.y)
	
	car.add_to_group("enemies")
	
	add_child(car)
