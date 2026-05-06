extends Node2D

signal finished(success: bool)
@onready var timer = $Timer
@onready var countdown_sprite = $AnimatedSprite2D

func _ready():
	timer.start()
	countdown_sprite.play("countdown")

func _on_timer_timeout() -> void:
	finished.emit(false)

func _on_goal_body_entered(body):
	if body.name == "Character":
		body.play_win()
		await get_tree().create_timer(1.0).timeout
		finished.emit(true)
