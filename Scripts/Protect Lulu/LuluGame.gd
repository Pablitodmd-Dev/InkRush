extends Node2D

signal finished(success: bool)
var raindrop_scene = preload("res://Scenes/Microgames/Protect Lulu/raindrop.tscn")

@onready var timer = $Timer
@onready var countdown_sprite = $AnimatedSprite2D

func _ready():
	timer.start()
	countdown_sprite.play("countdown")

func _on_rain_timer_timeout():
	var raindrop = raindrop_scene.instantiate()
	raindrop.position = Vector2(randf_range(0, 1152), -50)
	add_child(raindrop)

func _on_timer_timeout():
	finished.emit(true)
