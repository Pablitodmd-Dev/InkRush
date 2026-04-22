# Main.gd
extends Node2D

@onready var archer = $Archer 

func _ready():
	for target in get_tree().get_nodes_in_group("target"):
		target.hit_fruit.connect(archer.play_win_animation)
