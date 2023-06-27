extends Reference


func check_availability():
	var has : bool = PlayerStats.lighters     [PlayerStats.LIGHTER_FANCIFUL] > 0
	var used: bool = PlayerStats.used_lighters[PlayerStats.LIGHTER_FANCIFUL] > 0
	return !used and !has

func get_purchased():
	PlayerStats.gain_lighter(PlayerStats.LIGHTER_FANCIFUL)
