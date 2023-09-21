extends Node


export (String) var property = ""
export var value = ""


func activate():
	get_parent().set(property, value)
