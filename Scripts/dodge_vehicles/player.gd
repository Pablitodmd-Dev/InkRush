extends CharacterBody2D

@export var speed: float = 600.0
var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		
	move_and_slide()
	
	var sprite_width = $CollisionShape2D.shape.get_rect().size.x / 2
	global_position.x = clamp(global_position.x, 0 + sprite_width, screen_size.x - sprite_width)
