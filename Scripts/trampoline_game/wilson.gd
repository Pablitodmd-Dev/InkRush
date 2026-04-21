extends CharacterBody2D

@onready var anim_player = %AnimatedSprite2D

var speed = 350.0
var gravity = 500
var is_alive = true

func _physics_process(delta):
	if not is_alive:
		return

	# Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Horizontal Movement
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	
	# Flip Sprite
	handle_flip(direction)
	
	# Handle Animations
	update_animations()
	
	move_and_slide()

func handle_flip(direction):
	if direction != 0:
		anim_player.flip_h = (direction < 0)

func update_animations():
	if is_on_floor():
		if velocity.x != 0:
			anim_player.play("idle")
	else:
		# In the air
		if velocity.y < 0:
			anim_player.play("jump")
		else:
			anim_player.play("fall")

func die():
	is_alive = false
	modulate = Color.RED
