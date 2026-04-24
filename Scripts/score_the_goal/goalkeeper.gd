extends CharacterBody2D

var speed = 200.0
var direction = 1
var active = true

var limit_left = 185
var limit_right = 930

func _physics_process(_delta):
	if not active: return
	
	velocity.x = speed * direction
	move_and_slide()
	
	if global_position.x <= limit_left:
		direction = 1
	elif global_position.x >= limit_right:
		direction = -1

func dive(target_x: float):
	active = false
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", target_x, 0.2)
