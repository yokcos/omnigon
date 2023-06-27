extends "res://props/interactables/gate_vertical_ignitable.gd"


var obj_gate_fanciful: PackedScene = load("res://props/interactables/gate_vertical_fanciful.tscn")


func get_shifted():
	Game.replace_instance(self, obj_gate_fanciful.instance())

func _on_entity_detector_activated() -> void:
	$animator.play("pulsate")
