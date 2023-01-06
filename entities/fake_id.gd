extends "res://entities/upgrade.gd"


func _ready() -> void:
	if PlayerStats.check_upgrade("fake_id"):
		queue_free()

func activate() -> void:
	.activate()
	
	PlayerStats.gain_upgrade("fake_id")
	queue_free()
