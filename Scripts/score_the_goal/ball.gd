extends CharacterBody2D

var speed = Vector2.ZERO
var decelerate = 0.98 

func launch(target_position: Vector2):
	speed = (target_position - global_position).normalized() * 800
	
func _physics_process(delta):
	if speed.length() > 10:
		velocity = speed
		var collision = move_and_collide(velocity * delta)
		
		if collision:
			speed = Vector2.ZERO
		
		speed *= decelerate
		scale -= Vector2(0.01, 0.01) * delta * 20
