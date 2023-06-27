extends "res://props/interactables/gate_vertical_ignitable.gd"


var obj_gate_imaginary: PackedScene = load("res://props/interactables/gate_vertical_imaginary.tscn")


func get_shifted():
	Game.replace_instance(self, obj_gate_imaginary.instance())
