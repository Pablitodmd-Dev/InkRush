extends Node2D

var raindrop_scene = preload("res://Scenes/Microgames/Protect Lulu/raindrop.tscn")

func _on_rain_timer_timeout():
	var raindrop = raindrop_scene.instantiate()
	raindrop.position = Vector2(randf_range(0, 1152), -50)
	add_child(raindrop)
