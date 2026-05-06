extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

var speed = 150.0
var is_winning = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	anim.play("walk")

func _physics_process(delta):
	if is_winning:
		return

	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimiento constante
	velocity.x = speed
	move_and_slide()

func play_win():
	is_winning = true
	velocity = Vector2.ZERO
	anim.play("win")
	$AudioStreamPlayer2D.play()
