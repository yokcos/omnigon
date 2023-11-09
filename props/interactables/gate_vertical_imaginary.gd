extends "res://props/interactables/gate_vertical_ignitable.gd"


var obj_gate_fanciful: PackedScene = load("res://props/interactables/gate_vertical_fanciful.tscn")


func get_shifted():
	var index = get_position_in_parent()
	var new_gate = obj_gate_fanciful.instance()
	new_gate.position = global_position
	Game.deploy_instance(new_gate, global_position)
	
	queue_free()

func _on_entity_detector_activated() -> void:
	$animator.play("pulsate")
