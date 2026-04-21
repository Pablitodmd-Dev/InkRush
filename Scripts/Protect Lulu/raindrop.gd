extends Area2D

@export var speed = 400

func _process(delta):
	position.y += speed * delta
	if position.y > 700:
		queue_free()
