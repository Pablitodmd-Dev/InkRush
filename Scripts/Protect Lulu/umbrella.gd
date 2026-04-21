extends Area2D

@export var speed = 400

func _process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * speed * delta
	position.x = clamp(position.x, 0, 1152)

func _on_area_entered(area):
	area.queue_free()
