extends StatusEffect


var multiplier = 0.2


func _apply():
	._apply()
	
	father.air_friction_multiplier *= multiplier

func _expire():
	._expire()
	
	father.air_friction_multiplier /= multiplier
