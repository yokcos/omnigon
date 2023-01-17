extends Enemy


func _ready() -> void:
	$fsm/chase.wall_detector = $flippable/wall_detector
	assign_target()

func _process(delta: float) -> void:
	if $fsm.state_name == "hidden":
		var cam = Game.camera
		if cam:
			var rect: Rect2 = cam.get_visible_rect()
			var margins: Array = []
			
			margins.append( abs(global_position.x - rect.position.x) )
			margins.append( abs(global_position.y - rect.position.y) )
			margins.append( abs(rect.end.x - global_position.x) )
			margins.append( abs(rect.end.y - global_position.y) )
			
			var least_margin = margins.min()
			if least_margin < 32:
				GlobalSound.play_temp_music("suddenmimic")
				$fsm/hidden.set_state("chase")
	else:
		assign_target()


func assign_target():
	if !is_instance_valid($fsm/chase.target):
		var players = get_tree().get_nodes_in_group("players")
		if players.size() > 0:
			$fsm/chase.target = players[0]

func perform_attacc0():
	$flippable/hurtbox0.pulse()

func perform_attacc1() -> void:
	$flippable/hurtbox1.pulse()

func get_shifted():
	if $fsm.state_name == "hidden":
		GlobalSound.play_temp_music("suddenmimic")
		$fsm.set_state_string("chase")
	else:
		GlobalSound.cut_temp_music()
		$fsm.set_state_string("hidden")


func _on_entity_detector0_activated() -> void:
	$fsm/chase.set_state("attacc0")

func _on_entity_detector1_activated() -> void:
	$fsm/chase.set_state("attacc1")
