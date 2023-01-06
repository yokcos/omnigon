extends Node2D


export (String) var group = ""


func count():
	return get_tree().get_nodes_in_group(group)
