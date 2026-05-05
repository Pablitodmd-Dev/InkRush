extends Area2D

signal finished(success: bool)
@export var min_speed: float = 450.0
@export var max_speed: float = 600.0
var current_speed: float

func _ready():
	# Randomize speed for each car
	current_speed = randf_range(min_speed, max_speed)
	
	# Connect notifier to destroy itself
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _process(delta):
	global_position.y += current_speed * delta

func _on_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		print("GAME OVER - Crashed!")
		get_tree().paused = true
		get_parent().finished.emit(false)
