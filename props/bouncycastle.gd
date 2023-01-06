extends "res://props/mattress.gd"


const obj_radio = preload("res://props/radio.tscn")


func get_shifted():
	var new_radio = obj_radio.instance()
	Game.replace_instance(self, new_radio)
