extends Node2D


func _ready() -> void:
	GlobalSound.play_temp_music("theshootening")
	connect("tree_exiting", self, "_on_slain")


func _on_slain():
	Events.emit_signal("moneybags_ended")
	GlobalSound.play_temp_music("theshootening_aftermath")
