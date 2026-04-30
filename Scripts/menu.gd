extends CanvasLayer

@onready var start_screen = $start    
@onready var victory_screen = $completed 
@onready var defeat_screen = $failed   
@onready var brush_container = $HBoxContainer

@onready var controls_numbers = $numbers
@onready var horizontal_arrows = $horizontalArrows
@onready var vertical_arrows = $verticalArrows
@onready var onlyup = $onlyUp
@onready var onlyright = $onlyRight
@onready var allArrows=$allArrows

func _ready():
	hide_all()
	brush_container.show()

func hide_all():
	start_screen.hide()
	victory_screen.hide()
	defeat_screen.hide()
	brush_container.hide()

func show_screen(screen_type: String):
	hide_all()
	match screen_type:
		"start":
			start_screen.show()
			brush_container.show()
		"completed":
			victory_screen.show()
			brush_container.show()
		"failed":
			defeat_screen.show()
			brush_container.show()

func update_brushes(lives_left: int):
	brush_container.show()
	var brushes = brush_container.get_children() 
	for i in range(brushes.size()):
		brushes[i].visible = i < lives_left
		
func hide_all_controls():
	controls_numbers.hide()
	horizontal_arrows.hide()
	vertical_arrows.hide()
	onlyup.hide()
	allArrows.hide()
	onlyright.hide()

func show_specific_controls(type):
	hide_all_controls()
	match type:
		"numbers":
			controls_numbers.show()
		"allArrows":
			allArrows.show()
		"horizontal":
			horizontal_arrows.show()
		"onlyup":
			onlyup.show()
		"onlyright":
			onlyright.show()
		"vertical":
			vertical_arrows.show()
		"none":
			pass
