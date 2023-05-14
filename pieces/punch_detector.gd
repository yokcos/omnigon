extends Area2D


signal punched


func get_punched():
	emit_signal("punched")
