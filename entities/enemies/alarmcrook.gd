extends Enemy


var target: Being = null


func _process(delta: float) -> void:
	if !is_instance_valid(target):
		target = Game.get_player()
		if is_instance_valid(target):
			$fsm/idle.target = target

func _on_entity_detector_activated() -> void:
	$fsm/idle.set_state("attacc")


func _on_attacc_activated() -> void:
	$flippable/hurtbox.pulse()


