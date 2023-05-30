class_name VendorWare
extends Resource


export (Texture) var image = null
export (String) var name = ""
export (String, MULTILINE) var description = ""
export (int) var cost = 118

export (GDScript) var availability_script = null
export (GDScript) var purchase_script = null

signal too_poor


func check_availability():
	if availability_script:
		var new_ava = availability_script.new()
		return new_ava.check_availability()
	return false

func get_purchased():
	if purchase_script:
		if PlayerStats.vertices >= cost:
			PlayerStats.vertices -= cost
			var new_buy = purchase_script.new()
			new_buy.get_purchased()
			return true
		else:
			emit_signal("too_poor")
			return false
	return false
