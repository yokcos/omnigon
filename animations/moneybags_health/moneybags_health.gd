extends Node2D


var hp_gained: bool = false
var father: Being = null


func gain_hp():
	if is_instance_valid(father):
		father.gain_hp()
		hp_gained = true

func _on_popup_hide():
	gain_hp()
