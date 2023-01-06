extends "res://entities/pickup.gd"


export (String) var upgrade_id = ""
export (String) var upgrade_name = ""
export (String, MULTILINE) var upgrade_desc = ""


signal collected




func _ready() -> void:
	obj_tooltip = preload("res://ui/pickup_announcement.tscn")
	
	if PlayerStats.check_upgrade(upgrade_id):
		queue_free()


func deploy_tooltip():
	var new_tooltip = .deploy_tooltip()
	new_tooltip.set_stuff(upgrade_name, upgrade_desc)

func activate() -> void:
	.activate()
	
	PlayerStats.gain_upgrade(upgrade_id)
	queue_free()



