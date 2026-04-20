extends Area2D

@export var bounce_force: float = -600.0
@onready var anim_player = $AnimatedSprite2D

func _on_body_entered(body):
	if body is CharacterBody2D:
		#Apply bounce to player
		body.velocity.y = bounce_force
		
		#Play spring animation
		anim_player.play("compress")
