extends Enemy


var obj_spikewall = load("res://props/spike_wall.tscn")
var obstructed: bool = false


func _process(delta: float) -> void:
	obstructed = $flippable/wall_detector.get_overlapping_bodies().size() > 0
	$fsm/attacc0.enabled = !obstructed


func _on_attacc0_activated() -> void:
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.randomise_pitch(0.5, 0.8)
	new_sfx.max_distance = 400
	
	var mattress = bounce()
	if !mattress:
		$flippable/hurtbox0.pulse(.4)
		
		new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_land, global_position)
		new_sfx.randomise_pitch(0.5, 0.8)
		new_sfx.relative_volume = 1.3
		new_sfx.max_distance = 400

func _on_attacc1_activated() -> void:
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.randomise_pitch(0.6, 0.9)
	new_sfx.max_distance = 400
	
	$flippable/hurtbox1.pulse(.4)

func _on_attacc1_exited() -> void:
	if flipped:
		velocity.x = -1
	else:
		velocity.x = 1


func reposition():
	if flipped:
		position -= Vector2(128, 0)
	else:
		position += Vector2(128, 0)
	
	$flippable/sprite.position = Vector2(48, -56)
	$flippable/sprite.frame = 0

func flop():
	var hits = $flippable/wall_detector.get_overlapping_bodies().duplicate()
	var wall_hits = false
	
	for thing in hits:
		if !thing.is_in_group("entities"):
			wall_hits = true
			break
	
	if !obstructed:
		$fsm/patrol.perform_action("attacc0")
		
		var mattress_position: Vector2 = Vector2(112, 8)
		mattress_position.x *= flip_int
		Game.summon_mattress_gremlin(global_position + mattress_position)

func bounce() -> bool:
	var mattress: bool = Game.is_instance_in_mattress(self) or Game.is_instance_in_mattress($flippable/wall_detector)
	
	if mattress:
		$fsm.set_state_string("unattacc")
	
	return mattress

func get_shifted():
	var new_spikewall = obj_spikewall.instance()
	Game.replace_instance(self, new_spikewall)



