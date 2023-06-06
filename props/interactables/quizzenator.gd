extends Node2D


var questions: Array = []


func _ready() -> void:
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
			"Molotov cocktails",
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
