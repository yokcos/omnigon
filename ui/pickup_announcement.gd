extends "res://ui/announcement.gd"


func _ready():
	$panel/bac/instruction.text = "Upgrades are auto-equipped forevermore\nPress '%s' to grab" % Game.get_input_string("interact")

func set_stuff(title, desc):
	$panel/bac/title.text = title
	$panel/bac/description.text = desc
