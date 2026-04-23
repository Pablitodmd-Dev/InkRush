extends Node2D

var buttons = []
var redButtons = []
var randomButtons
var correctButton = 0

func _ready():
	buttons = $GridContainer.get_children()
	colorButtons()

func colorButtons():
	while redButtons.size() < 4:
		randomButtons = randi_range(0, buttons.size() - 1)
		
		if !redButtons.has(randomButtons):
			redButtons.push_back(randomButtons)
			
			var style = StyleBoxFlat.new()
			style.bg_color = Color(1, 0, 0) # Red
			buttons[randomButtons].add_theme_stylebox_override("normal", style)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var button_index = event.keycode - KEY_1
			_on_pressed_button(button_index)

func _on_pressed_button(numberButton):
	if numberButton >= buttons.size():
		return

	if redButtons.has(numberButton):
		var style = StyleBoxFlat.new()
		%correctOption.play()
		style.bg_color = Color(0.0, 0.561, 0.0, 1.0) # Green
		buttons[numberButton].add_theme_stylebox_override("normal", style)
		
		correctButton += 1
		redButtons.erase(numberButton)
		
		if correctButton == 4:
			%win.play()
			$AnimatedSprite2D.play("repaired")
			$GridContainer.visible = false
	else:
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.463, 0.068, 0.535, 1.0) # Purple/Error
		buttons[numberButton].add_theme_stylebox_override("normal", style)
		
		%incorrectOption.play()
		await %incorrectOption.finished
		get_tree().quit()

func resetButtons():
	for btn in buttons:
		btn.remove_theme_stylebox_override("normal")
		
func _on_timer_timeout() -> void:
	resetButtons()
