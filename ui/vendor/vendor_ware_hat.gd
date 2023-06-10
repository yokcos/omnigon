tool
class_name VendorWareHat
extends VendorWare


export (Resource) var hat = null setget set_hat


func check_availability():
	print("Checking")
	return !PlayerStats.available_hats.has(hat)

func get_purchased():
	if PlayerStats.vertices >= cost:
		PlayerStats.vertices -= cost
		PlayerStats.gain_hat(hat)
		return true
	else:
		emit_signal("too_poor")
		return false

func set_hat(what: Hat):
	hat = what
	
	image = what.large_sprite
	name = what.name
	description = what.description
