extends CharacterBody2D

var speed = 300.0

func _ready():
	var angle = randf_range(0, 2 * PI)
	velocity = Vector2(cos(angle), sin(angle)) * speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
