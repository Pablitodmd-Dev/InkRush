extends Node2D

signal finished(success: bool)

# Nodes references
@onready var ball = $Ball
@onready var power_bar = $PowerBar
@onready var goal_label = $GoalLabel

# Game Settings
var charge_speed = 60.0
var ball_speed = 750.0
var charging = false
var ball_velocity = Vector2.ZERO
var initial_ball_pos = Vector2.ZERO
var is_goal = false 

# Physics Settings
var goal_line_y = 41.0

func _ready():
	initial_ball_pos = ball.global_position
	power_bar.value = 0
	power_bar.max_value = 100
	power_bar.step = 0.01
	if goal_label:
		goal_label.visible = false

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
			_on_shot_complete()
		else:
			ball.position = next_pos

func _process_shot(final_power):
	var direction = Vector2.ZERO
	
	if final_power <= 40.0:
		#RED Miss
		direction = Vector2(-1.5, -1).normalized()
		is_goal = false
		
	elif final_power <= 55.0:
		#GREEN Goal
		direction = Vector2(randf_range(-0.1, 0.1), -1).normalized()
		is_goal = true
		
	else:
		#YELLOW 50/50
		if randf() > 0.5:
			direction = Vector2(0.2, -1).normalized()
			is_goal = true
		else:
			direction = Vector2(1.5, -1).normalized()
			is_goal = false

	ball_velocity = direction * ball_speed

func _on_shot_complete():
	if is_goal:
		if goal_label:
			goal_label.text = "GOAL!"
			goal_label.visible = true
		
		await get_tree().create_timer(1.5).timeout
		finished.emit(true)
	else:
		await get_tree().create_timer(1.0).timeout
		finished.emit(false)
