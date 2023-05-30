extends Reference


func check_availability():
	return !PlayerStats.check_upgrade("rapiers")

func get_purchased():
	PlayerStats.gain_upgrade("rapiers")
