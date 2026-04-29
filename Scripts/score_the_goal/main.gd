extends Node2D

# Nodes references
@onready var ball = $Ball
@onready var power_bar = $PowerBar

# Game Settings
var charge_speed = 60.0
var ball_speed = 750.0
var charging = false
var ball_velocity = Vector2.ZERO
var initial_ball_pos = Vector2.ZERO

# Physics Settings
var goal_line_y = 41.0

func _ready():
	initial_ball_pos = ball.global_position
	power_bar.value = 0
	power_bar.max_value = 100
	power_bar.step = 0.01

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		charging = true
		power_bar.value = 0
		
	if charging:
		power_bar.value += charge_speed * delta
		if power_bar.value >= 100:
			power_bar.value = 0
		
		if Input.is_action_just_released("ui_up"):
			charging = false
			_process_shot(power_bar.value)

	if ball_velocity != Vector2.ZERO:
		var next_pos = ball.position + (ball_velocity * delta)
		
		if next_pos.y <= goal_line_y:
			ball.position.y = goal_line_y
			ball_velocity = Vector2.ZERO
		else:
			ball.position = next_pos

func _process_shot(final_power):
	var direction = Vector2.ZERO
	print("Shot Power: ", final_power)
	
	if final_power <= 40.0:
		# ZONE: RED Missed wide left
		direction = Vector2(-1.5, -1).normalized()
		print("RESULT: RED - Missed!")
		
	elif final_power <= 50.0:
		# ZONE: GREEN Goal
		direction = Vector2(randf_range(-0.1, 0.1), -1).normalized()
		print("RESULT: GREEN - Goal!")
		
	else:
		# ZONE: YELLOW 50/50 Chance
		if randf() > 0.5:
			direction = Vector2(0.2, -1).normalized()
			print("RESULT: YELLOW - Lucky Goal!")
		else:
			direction = Vector2(1.5, -1).normalized()
			print("RESULT: YELLOW - Missed!")

	ball_velocity = direction * ball_speed
	
	await get_tree().create_timer(3.0).timeout
	_restart_round()

func _restart_round():
	ball_velocity = Vector2.ZERO
	ball.global_position = initial_ball_pos
	power_bar.value = 0
	print("--- READY FOR NEXT SHOT ---")
