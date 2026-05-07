extends Area2D

@export var speed = 400

func _process(delta):
	if Global.difficulty_level == 0:
		speed = 400
	elif Global.difficulty_level == 1:
		speed = 350.0
	elif Global.difficulty_level == 2:
		speed = 300.0
		
	position.y += speed * delta
	if position.y > 700:
		queue_free()
