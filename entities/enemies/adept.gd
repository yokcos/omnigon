extends Enemy


var obj_ascendator = load("res://entities/enemies/ascendator.tscn")
var has_target = false


func _process(delta: float) -> void:
	if has_target:
		$fsm/patrol.perform_action_random(["attacc0", "attacc1"])


func perform_attacc0():
	$flippable/hurtbox0.pulse(.2)
	
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.randomise_pitch(0.8, 1.2)

func perform_attacc1():
	$flippable/hurtbox1.pulse(.2)
	
	var new_sfx: SFX2D = null
	new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.randomise_pitch(0.8, 1.2)
	
	new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_pop, global_position)
	new_sfx.relative_volume = 1.5
	new_sfx.randomise_pitch(0.8, 1.2)


func launch_attacc():
	var possibilities = ["attacc0", "attacc1"]
	$fsm/patrol.perform_action_random(possibilities)

func launch_head():
	$fsm/patrol.perform_action("attacc1")


func get_shifted():
	Game.replace_instance(self, obj_ascendator.instance())


func _on_entity_detector_updated(what: Array) -> void:
	has_target = what.size() > 0
