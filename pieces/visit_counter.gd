extends Node


export (int) var threshhold = 1


signal threshhold_met
signal threshhold_not_met


func _ready() -> void:
	if WorldSaver.load_data("visits") > threshhold:
		emit_signal("threshhold_met")
	else:
		emit_signal("threshhold_not_met")
