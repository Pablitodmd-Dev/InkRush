extends Area2D

@export var bounce_force: float = -1000.0
@export var move_speed: float = 100.0
@export var horizontal_limit: float = 200.0

var is_moving: bool = false
var direction: int = 1
var center_x: float

@onready var anim_player: AnimatedSprite2D = %AnimatedSprite2D
@onready var audioplayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():

	center_x = global_position.x 

func _process(delta):
	if is_moving:

		global_position.x += move_speed * direction * delta
		

		if global_position.x > center_x + horizontal_limit:
			direction = -1
		elif global_position.x < center_x - horizontal_limit:
			direction = 1 

func _on_body_entered(body):
	if body is CharacterBody2D:

		body.velocity.y = bounce_force
		
		anim_player.play("compress")
		audioplayer.play()
		if not is_moving:
			is_moving = true
