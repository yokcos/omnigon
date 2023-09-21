extends Reference


func check_availability():
	return true

func get_purchased():
	Events.emit_signal("instant_money_change")
	PlayerStats.vertices += 118
