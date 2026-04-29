extends Area2D

signal hit_fruit

func emit_hit_signal():
	hit_fruit.emit()
	await get_tree().create_timer(1.0).timeout
	get_parent().finished.emit(true)
