extends Node2D
var questions={}
var index=0
var correctAnswer=1

func _ready():
	questions = readQuestions()
	$%optionA.grab_focus()
	newQuestion()
	
func readQuestions():
	var file = FileAccess.open("res://Assets/Microgames/The Last Lesson/questionsAnswers.txt", FileAccess.READ)
	var content = file.get_as_text()
	var parseContent=JSON.parse_string(content)
	return parseContent

func newQuestion():
	index = randi_range(0, questions.size() - 1)
	%Question.text=(questions[index].question)
	#print(preguntas[0].respuestas.size())
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
	if correctAnswer>=1:
		#print('Ganaste')
		get_tree().quit()
	else:
		if valor == "true":
			#print("bien")
			correctAnswer+=1
			questions.pop_at(index)
			newQuestion()
			
		else:
			print("mal")
			get_tree().quit()
		#print(questions)

		#print(questions)
