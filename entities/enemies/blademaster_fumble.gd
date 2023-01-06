extends State


var duration: float = 2


func _step(delta: float):
	._step(delta)
	
	if PlayerStats.check_upgrade("blademaster_recover"):
		if age > duration:
			set_state("recover")
