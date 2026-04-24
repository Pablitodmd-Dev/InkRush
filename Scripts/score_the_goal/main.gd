extends Node2D

@onready var ball = $Ball
@onready var keeper = $Goalkeeper
@onready var bar = $PowerBar

@onready var ball_start_pos = ball.global_position

func _input(event):
	# 1. INICIO: Al presionar "ui_up", reseteamos la barra y empezamos a moverla
	if event.is_action_pressed("ui_up"):
		bar.reset_bar()
		bar.moving = true
	
	# 2. FIN: Al soltar "ui_up", si la barra se estaba moviendo, disparamos
	elif event.is_action_released("ui_up") and bar.moving:
		bar.moving = false # Detenemos la barra inmediatamente
		var quality = bar.get_power_quality()
		calculate_shot(quality)

func calculate_shot(quality: String):
	var random_val = randf()
	var goal_pos = Vector2(640, 200) 
	
	if quality == "green":
		goal_pos.x += randf_range(-150, 150)
		ball.launch(goal_pos)
		
	elif quality == "yellow":
		goal_pos.x += randf_range(-100, 100)
		ball.launch(goal_pos)
		if random_val > 0.7:
			keeper.dive(goal_pos.x) 
			
	elif quality == "red":
		goal_pos.x += randf_range(-50, 50)
		ball.launch(goal_pos)
		if random_val > 0.2:
			keeper.dive(goal_pos.x)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		print("¡GOL! Reiniciando...")
		await get_tree().create_timer(1.0).timeout
		restart_game()

func restart_game():
	ball.global_position = ball_start_pos
	ball.speed = Vector2.ZERO
	ball.scale = Vector2(1, 1)
	
	keeper.active = true
	keeper.global_position = Vector2(551, 250)
	
	# Aseguramos que la barra esté quieta al reiniciar
	bar.value = 0
	bar.moving = false
