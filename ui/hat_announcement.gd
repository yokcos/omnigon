extends "res://ui/announcement.gd"


var hat: Hat = null


func _ready():
	$panel/bac/instruction.text = "You may switch hats in\ntimes of rejuvenation\nPress '%s' to grab" % Game.get_input_string("interact")

func set_hat(what: Hat):
	hat = what
	
	$panel/bac/title.text = what.name
	$panel/bac/image.texture = what.large_sprite
	$panel/bac/description.text = what.description
