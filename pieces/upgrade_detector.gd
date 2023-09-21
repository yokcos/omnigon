extends Node


export (String) var upgrade = "rapiers"


signal activated


func _ready() -> void:
	if PlayerStats.check_upgrade(upgrade):
		emit_signal("activated")
