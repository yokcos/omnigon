extends "res://ui/announcement.gd"


var hat: Hat = null


func set_hat(what: Hat):
	hat = what
	
	$panel/bac/title.text = what.name
	$panel/bac/image.texture = what.large_sprite
	$panel/bac/image.hframes = what.large_frames
	$panel/bac/description.text = what.description
