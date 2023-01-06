extends "res://ui/announcement.gd"



func _ready() -> void:
	$panel/bac/instruction.text = "Lighters shatter after one use\nPress '%s' to grab" % Game.get_input_string("interact")

func set_stuff(title, desc):
	$panel/bac/title.text = title
	$panel/bac/description.text = desc
