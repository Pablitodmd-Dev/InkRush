extends Node2D

@onready var archer = $Archer
@onready var timer = $Timer
@onready var countdown_sprite = $AnimatedSprite2D

func _ready():
	timer.start()
	countdown_sprite.play("countdown")

	for target in get_tree().get_nodes_in_group("target"):
		target.hit_fruit.connect(archer.play_win_animation)

func _on_timer_timeout() -> void:
	get_tree().quit()
