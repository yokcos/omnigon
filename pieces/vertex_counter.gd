extends Node2D


export (float) var default = 10



func count():
	var value = 0
	for i in get_tree().get_nodes_in_group("vertices"):
		value += i.value
	
	return value
