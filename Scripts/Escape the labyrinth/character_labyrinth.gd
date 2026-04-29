extends CharacterBody2D 

@export var speed = 200
var has_won = false

func _physics_process(delta):
	if has_won:
		velocity = Vector2.ZERO
		return

	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

func _on_area_2d_area_entered(area):
	if area.name == "Goal":
		has_won = true
		$AnimatedSprite2D.play("win")
		$AudioStreamPlayer2D.play()
		get_parent().finished.emit(true)
