extends CharacterBody2D

const SPEED = 300.0

func _physics_process(_delta):
	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
		
		if direction.x < 0 and direction.y < 0:
			$AnimatedSprite2D.play("up_left")
		elif direction.x > 0 and direction.y < 0:
			$AnimatedSprite2D.play("up_right")
		elif direction.x < 0 and direction.y > 0:
			$AnimatedSprite2D.play("down_left")
		elif direction.x > 0 and direction.y > 0:
			$AnimatedSprite2D.play("down_right")
			
		elif direction.x < 0:
			$AnimatedSprite2D.play("left")
		elif direction.x > 0:
			$AnimatedSprite2D.play("right")
		elif direction.y < 0:
			$AnimatedSprite2D.play("up")
		elif direction.y > 0:
			$AnimatedSprite2D.play("down")
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("balls"):
		get_tree().reload_current_scene()
