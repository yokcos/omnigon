extends Node2D


var target: Node2D = null


func _process(delta: float) -> void:
	follow_target()

func follow_target():
	if is_instance_valid(target):
		global_position = target.global_position
