extends Node2D

func _on_goal_body_entered(body):
	print("¡Algo ha entrado en la meta! Es: ", body.name)
	if body.name == "Character": 
		body.play_win()
