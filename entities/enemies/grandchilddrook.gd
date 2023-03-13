extends Enemy



func _process(delta: float) -> void:
	accelerate(flip_int, delta)


func _on_wall_detector_activated() -> void:
	set_hp(0)

func _on_attacc_activated() -> void:
	$flippable/hurtbox.pulse()


func _on_destructor_timeout() -> void:
	set_hp(0)
