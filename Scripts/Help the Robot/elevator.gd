extends AnimatableBody2D

@export var pos_a: Vector2 
@export var pos_b: Vector2 

var duration: float = 0.1 

func _ready():
	if Global.difficulty_level == 0:
		duration = 0.1 
	elif Global.difficulty_level == 1:
		duration = 0.5  
	elif Global.difficulty_level == 2:
		duration = 1.0  

func _input(event):
	if event.is_action_pressed("ui_up"):
		mover_suave(pos_b)
	elif event.is_action_pressed("ui_down"):
		mover_suave(pos_a)

func mover_suave(target_pos):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_pos, duration)
