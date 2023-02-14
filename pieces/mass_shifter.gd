extends Node2D


func activate():
	for i in get_children():
		if i.has_method("get_shifted"):
			i.get_shifted()
