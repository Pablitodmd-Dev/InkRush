extends CharacterBody2D

const SPEED = 300.0
signal finished(success: bool)


func _physics_process(_delta):
	var direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
		
		if direction.x < 0 and direction.y < 0:
			$AnimatedSprite2D.play("up_left")
			%diagonal.disabled=false
			
		elif direction.x > 0 and direction.y < 0:
			$AnimatedSprite2D.play("up_right")
			%diagonal2.disabled=false
		elif direction.x < 0 and direction.y > 0:
			$AnimatedSprite2D.play("down_left")
			%diagonal2.disabled=false
		elif direction.x > 0 and direction.y > 0:
			$AnimatedSprite2D.play("down_right")
			%diagonal.disabled=false
		elif direction.x < 0:
			$AnimatedSprite2D.play("left")
			%horizontal.disabled=false
		elif direction.x > 0:
			$AnimatedSprite2D.play("right")
			%horizontal.disabled=false
		elif direction.y < 0:
			$AnimatedSprite2D.play("up")
			%vertical.disabled=false
		elif direction.y > 0:
			$AnimatedSprite2D.play("down")
			%vertical.disabled=false
	else:
		velocity = Vector2.ZERO
		_hide_collisions()
		
		$AnimatedSprite2D.stop()
		
	move_and_slide()

func _hide_collisions():
	%horizontal.disabled=true
	%diagonal2.disabled=true
	%vertical.disabled=true
	%diagonal.disabled=true


func _on_area_2d_body_entered(body):
	if body.is_in_group("balls"):
		get_parent().finished.emit(false)
