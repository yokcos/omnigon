extends Node


func activate():
	get_parent().queue_free()
