extends Enemy


var obj_bell = load("res://entities/enemies/bell.tscn")


func _process(delta: float) -> void:
	accelerate(flip_int, delta)


func get_shifted():
	var new_bell = obj_bell.instance()
	Game.replace_instance(self, new_bell)


func _on_wall_detector_activated() -> void:
	set_hp(0)

func _on_attacc_activated() -> void:
	$flippable/hurtbox.pulse()
	var new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_tick, global_position)
	new_sfx.randomise_pitch(0.4, 0.6)


func _on_destructor_timeout() -> void:
	set_hp(0)
