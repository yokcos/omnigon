extends Node2D

var duration = 5
var age = 0
var width = 20
var depth = 0
var length = 320 setget set_length

func _process(delta):
	age += delta
	var ratio = age/duration
	if ratio >= 1:
		queue_free()
	
	var degree = 1 - 4*pow(ratio-0.5, 2)
	degree *= width
	
	$visual.polygon[0].x = -degree
	$visual.polygon[1].x =  degree
	$visual.polygon[2].x = length/2 + degree
	$visual.polygon[3].x = length/2 - degree
	
	position.y -= depth*5*delta

func set_length(what):
	length = what
	
	$visual.polygon[2].y = length
	$visual.polygon[3].y = length
