extends StaticBody2D


const obj_sawhead = preload("res://entities/enemies/sawhead.tscn")


func get_shifted():
	var new_sawhead = obj_sawhead.instance()
	Game.replace_instance(self, new_sawhead)
