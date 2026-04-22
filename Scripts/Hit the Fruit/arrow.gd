extends Area2D

@export var speed = 800
var has_hit = false 

func _physics_process(delta):
	if not has_hit:
		position += transform.x * speed * delta

func _on_area_entered(area):
	if area.is_in_group("target") and not has_hit:
		has_hit = true 
		set_physics_process(false) 
		if area.has_method("emit_hit_signal"):
			area.emit_hit_signal()
