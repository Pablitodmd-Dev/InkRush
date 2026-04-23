extends Node2D

var buttons = []
var redButtons=[]
var randomButtons
var correctButton=0

func _ready():
	buttons = $GridContainer.get_children()
	for i in range(buttons.size()):
		buttons[i].pressed.connect(_on_pressed_button.bind(i))
	colorButtons()

func colorButtons():
	while redButtons.size() < 4:
		randomButtons = randi_range(0, 9 - 1)
		
		if !redButtons.has(randomButtons):
			redButtons.push_back(randomButtons)
			
			var style = StyleBoxFlat.new()
			style.bg_color = Color(1, 0, 0) 
			buttons[randomButtons].add_theme_stylebox_override("normal", style)
		

func _on_pressed_button(numberButton):
	if redButtons.has(numberButton):
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.0, 0.561, 0.0, 1.0) 
		buttons[numberButton].add_theme_stylebox_override("normal", style)
		correctButton+=1
		redButtons.erase(numberButton)
		if(correctButton==4):
			$AnimatedSprite2D.play("repaired")
			$GridContainer.visible=false
	else:
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.463, 0.068, 0.535, 1.0) 
		buttons[numberButton].add_theme_stylebox_override("normal", style)
		get_tree().quit()

func resetButtons():
	for btn in buttons:
		btn.remove_theme_stylebox_override("normal")
		
func _on_timer_timeout() -> void:
	resetButtons()
