extends Enemy


var obj_dummy = load("res://entities/enemies/dummy.tscn")


func _ready() -> void:
	if !extra_data.has("fallen"):
		extra_data["fallen"] = false

func _process(delta: float) -> void:
	if PlayerStats.check_upgrade("rapiers"):
		$fsm/patrol.set_state("patrol_r")
		$fsm/attacc.set_state("attacc_r0")
	else:
		$fsm/patrol_r.set_state("patrol")
		$fsm/attacc_r0.set_state("attacc")


func get_loaded(data):
	if data:
		.get_loaded(data)
		
		if data["fallen"]:
			$fsm.set_state($fsm/fumble)


func _on_attacc_activated() -> void:
	if !bounce():
		$flippable/hurtbox.pulse(.4)
	
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.relative_volume = 0.6
	new_sfx.randomise_pitch(0.8, 1.2)

func _on_attacc_r_activated() -> void:
	$flippable/hurtbox_r.pulse()
	
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.relative_volume = 0.6
	new_sfx.randomise_pitch(1.0, 1.4)

func _on_state_changed(old_state, new_state) -> void:
	if new_state == $fsm/fumble:
		extra_data["fallen"] = true


func get_shifted():
	Game.replace_instance(self, obj_dummy.instance())

func bounce() -> bool:
	var mattress: bool = Game.is_instance_in_mattress(self) or Game.is_instance_in_mattress($flippable/entity_detector)
	if mattress:
		$fsm.set_state_string("unattacc")
	return mattress

func fall():
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_blademaster_fall, global_position)


func _on_entity_detector_activated() -> void:
	# Apply hat Peace
	if !PlayerStats.has_hat("peace"): # Check if the relevant hat is equipped
		# Everything below pretty much means "Do an attack"
		if $fsm/patrol.perform_action("attacc"):
			var mattress_position: Vector2 = Vector2(16, 8)
			mattress_position.x *= flip_int
			Game.summon_mattress_gremlin(global_position + mattress_position)
		
		$fsm/patrol_r.perform_action("attacc_r0")

func _on_fumble_entered() -> void:
	$headpat.active = true

func _on_fumble_exited() -> void:
	$headpat.active = true

func _on_headpat_activated() -> void:
	var player = Game.get_player()
	if is_instance_valid(player):
		player.pat_blademaster(self)
