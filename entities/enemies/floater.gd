extends Enemy


var has_target: bool = false
var obj_airhead: PackedScene = load("res://entities/enemies/airhead.tscn")


func _process(delta: float) -> void:
	if has_target:
		$fsm/patrol.perform_action($fsm/patrol.attack_state)


func get_loaded(data):
	if data:
		.get_loaded(data)
	
	for ladder in get_tree().get_nodes_in_group("ladders"):
		add_collision_exception_with(ladder.get_node("top"))

func get_shifted():
	Game.replace_instance(self, obj_airhead.instance())


func _on_attacc_activated() -> void:
	$flippable/hurtbox.pulse(.4)
	
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.relative_volume = 0.9
	new_sfx.randomise_pitch(0.4, 0.6)

func _on_entity_detector_updated(entities: Array) -> void:
	if entities.size() > 0:
		$fsm/patrol.target = entities[0]
	else:
		$fsm/patrol.target = null

func _on_player_detector_updated(what: Array) -> void:
	has_target = what.size() > 0
