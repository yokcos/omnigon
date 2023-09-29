extends Node


export (String) var sig

signal activated


func _ready() -> void:
	Events.connect(sig, self, "_on_signal_caught")


func _on_signal_caught():
	emit_signal("activated")
