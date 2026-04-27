extends Node2D

var buttons = []
var redButtons = []
var randomButtons
var correctButton = 0

@onready var countdown_timer=$Timer2
@onready var countdown_sprite=$AnimatedSprite2D2

func _ready():
	buttons = $GridContainer.get_children()
	colorButtons()
	countdown_timer.start(7.0) 
	countdown_sprite.play("countdown")

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
		set_process_input(false)
		
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.463, 0.068, 0.535, 1.0) 
		buttons[numberButton].add_theme_stylebox_override("normal", style)
		
		%incorrectOption.play()
		await %incorrectOption.finished
		get_tree().quit()

func resetButtons():
	for btn in buttons:
		btn.remove_theme_stylebox_override("normal")
		
func _on_timer_timeout() -> void:
	resetButtons()


func _on_timer_2_timeout() -> void:
	get_tree().quit()
