extends Area2D

@export var speed = 150
var direction = 1
var timer = 0.0
var is_hit = false

func _ready():
	$AnimatedSprite2D.play("walk")

func _process(delta):
	if is_hit:
		return

	if not $AnimatedSprite2D.is_playing() or $AnimatedSprite2D.animation != "walk":
		$AnimatedSprite2D.play("walk")

	timer += delta
	if timer > 1.0:
		if randf() < 0.5:
			direction *= -1
			$AnimatedSprite2D.flip_h = (direction < 0)
		timer = 0.0
	
	position.x += direction * speed * delta
	position.x = clamp(position.x, 50, 1102)

func _on_area_entered(area):
	if area.is_in_group("raindrops") and not is_hit:
		is_hit = true
		area.queue_free()
		$AudioStreamPlayer2D.play()
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.modulate = Color(0.3, 0.3, 0.3, 1)
