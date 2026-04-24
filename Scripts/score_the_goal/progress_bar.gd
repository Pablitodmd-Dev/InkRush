extends TextureProgressBar

@export var movement_speed: float = 0.5 
var moving: bool = true
var time_passed: float = 0.0

func _process(delta):
	if not moving:
		return
	
	time_passed += delta * movement_speed
	
	value = (sin(time_passed * 3.0) + 1.0) / 2.0 * 100.0

func get_power_quality() -> String:
	moving = false
	if value > 40 and value < 60:
		return "green"
	elif value > 15 and value < 85:
		return "yellow"
	else:
		return "red"

func reset_bar():
	value = 0
	time_passed = 0
	moving = true
