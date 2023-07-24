extends Node2D


var father: Being = null


func gain_hp():
	if is_instance_valid(father):
		father.gain_hp()
