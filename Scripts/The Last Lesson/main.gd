extends Node2D
var questions={}
var index=0
signal finished(success: bool)


@onready var countdown_timer=$Timer
@onready var countdown_sprite=$AnimatedSprite2D


func _ready():
	var time_limit = 7.0
	var anim_speed = 1.0
	
	if Global.difficulty_level == 1:
		time_limit = 5.5
		anim_speed = 1.27 
	elif Global.difficulty_level == 2:
		time_limit = 4.0
		anim_speed = 1.75 

	questions = readQuestions()
	$%optionA.grab_focus()
	newQuestion()
	
	countdown_timer.start(time_limit) 
	countdown_sprite.speed_scale = anim_speed 
	countdown_sprite.play("countdown")
	
func readQuestions():
	var file = FileAccess.open("res://Assets/Microgames/The Last Lesson/questionsAnswers.json", FileAccess.READ)
	var content = file.get_as_text()
	var parseContent=JSON.parse_string(content)
	return parseContent

func newQuestion():
	index = randi_range(0, questions.size() - 1)
	%Question.text=(questions[index].question)
	$%optionA.text=questions[index].answers[0].keys()[0]
	%optionB.text=questions[index].answers[1].keys()[0]
	%optionC.text=questions[index].answers[2].keys()[0]
	
func _on_option_a_pressed() -> void:
	checkAnswer(questions[index].answers[0].values()[0])

func _on_option_b_pressed() -> void:
	checkAnswer(questions[index].answers[1].values()[0])

func _on_option_c_pressed() -> void:
	checkAnswer(questions[index].answers[2].values()[0])

func checkAnswer(valor):
		if valor == "true":
			print("bien")
			finished.emit(true)

		else:
			print("mal")
			
			finished.emit(false)

func _on_timer_timeout() -> void:
	get_tree().quit()
