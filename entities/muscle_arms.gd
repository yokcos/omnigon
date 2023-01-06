extends "res://entities/upgrade.gd"


func activate() -> void:
	.activate()
	
	PlayerStats.gain_upgrade("blademaster_recover")
	queue_free()
