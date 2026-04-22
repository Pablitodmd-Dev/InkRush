extends Area2D

signal hit_fruit

func emit_hit_signal():
	hit_fruit.emit()
