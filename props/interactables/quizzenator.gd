extends Node2D


export (NodePath) var screen_path
export (NodePath) var regurgitator_path
export (String, MULTILINE) var correct_answer_text = ""
export (Vector2) var emetic_dispenser_location = Vector2()
var questions: Array = []
var current_quiz: Control = null

const obj_quiz = preload("res://ui/quiz_screen.tscn")
const obj_emetic_dispenser = preload("res://props/interactables/emetic_dispenser.tscn")

signal correct
signal wrong


func _ready() -> void:
	randomize()
	deactivate()
	add_question(
		"Whomst rules this here Empaire?", [
			"The Emperor of course",
			"I do",
			"Lord Moneybags",
			"This guy you haven't heard of called Frank",
		]
	)
	add_question(
		"What are they researching in this facility?", [
			"Something about time travel",
			"How to make the Ultimate Haggis",
			"Why your face is so ugly",
			"This guy you haven't heard of called Frank",
		]
	)
	add_question(
		"What's the square root of nine?", [
			"Negative three",
			"Eighty-one",
			"It's too large for this margin",
			"Nine and a half",
		]
	)
	add_question(
		"Whomst first took the stand against them fucking elves?", [
			"The great hero Zorp",
			"The Queen of Bones",
			"Nobody did",
			"This guy you haven't heard of called Frank",
		]
	)
	add_question(
		"Capybara Cheese is an important ingredient in what traditional recipe?", [
			"Grilled Capybara Cheese sandwiches",
			"Bomb cocktails",
			"The Stone of Philosophers",
			"Greater Fruitcake",
		]
	)
	add_question(
		"In what bodily organ do you currently dwell?", [
			"The Stomach of Digestion",
			"The Lung of Breath",
			"The Bowel of Pooping",
			"The Bone of Structure",
		]
	)
	add_question(
		"How many suns were there this morning?", [
			"Only one",
			"One for every hour of the day",
			"There wasn't one at that time",
			"Two: One greater, and one lesser",
		]
	)
	add_question(
		"What is the type of shark called in the game Fishticuffs?", [
			"A hammerhead shark",
			"The Final Shark",
			"Combat shark",
			"Type is not specified but its name is Sharky McSharkface",
		]
	)
	add_question(
		"Which of these is an obstacle to time travel research", [
			"Researchers getting mysteriously head-exploded",
			"Lack of funding from the Emperor",
			"Constant raids by them fucking elves",
			"This guy you haven't heard of called Frank",
		]
	)
	add_question(
		"Would you like to get this question right?", [
			"Yes",
			"No",
			"No",
			"No",
		]
	)


func add_question( question: String, answers: Array ):
	# First answer will be the correct one
	var dict = {}
	dict["question"] = question
	dict["answers"] = answers
	questions.append(dict)

func deploy_quiz():
	var index: int = randi() % questions.size()
	var this_quiz = questions[index]
	
	var new_quiz = obj_quiz.instance()
	new_quiz.call_deferred("set_quiz", this_quiz)
	new_quiz.connect("selected", self, "_on_answer_selected")
	get_node(screen_path).add_child(new_quiz)
	current_quiz = new_quiz

func get_shifted():
	$animator.play("reset")

func activate():
	$interactable.active = true

func deactivate():
	$interactable.active = false

func correct_answer():
	Game.summon_popup("Sayeth Quizzenator", correct_answer_text, "Huzzah!", self)
	$vendor_piece.active = true
	$interactable.active = false
	
	var new_dispenser = obj_emetic_dispenser.instance()
	Game.deploy_instance(new_dispenser, emetic_dispenser_location)
	new_dispenser.regurgitator = get_node(regurgitator_path)
	new_dispenser.connect("activated", self, "_on_dispenser_activated")


func _on_answer_selected(which: int):
	if which == 0:
		emit_signal("correct")
		correct_answer()
	else:
		emit_signal("wrong")
	
	if is_instance_valid(current_quiz):
		current_quiz.queue_free()

func _on_interactable_activated() -> void:
	deploy_quiz()
	deactivate()

func _on_dispenser_activated():
	$interactable.active = false
	$vendor_piece.active = false
