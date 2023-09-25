extends Node2D


var destination: Vector2 = Vector2(-11622, -1934)
var eating: bool = false
var target: Node2D = null
var pulling: bool = false
var pull_power: float = 5

var obj_vendor = load("res://props/interactables/vendor.tscn")


func _process(delta: float) -> void:
	if is_instance_valid(target):
		track_target()
		if pulling:
			pull_target(delta)
			pull_power += 5*delta
			
			if $entity_detector.overlapping_entities.has(target):
				$animator.play("eat_post")
				$proceed_timer.start()
				pulling = false
				target.hide()
				GlobalSound.play_random_sfx(GlobalSound.sfx_nom)
	else:
		identify_target()


func eat():
	if !PlayerStats.has_hat("binlid"):
		$animator.play("eat_pre")

func tongueify():
	$tongue.show()
	pulling = true
	GlobalSound.play_random_sfx(GlobalSound.sfx_bleh)

func untongueify():
	$tongue.hide()

func proceed():
	Rooms.player_enter_room( destination )

func track_target():
	$tongue.points[1] = target.global_position - $tongue.global_position

func pull_target(delta: float):
	var instant_power = delta * pull_power
	instant_power = min(instant_power, 1)
	target.global_position = target.global_position.linear_interpolate( position, instant_power )
	target.set_state("stunned")

func identify_target():
	var player = Game.get_player()
	if is_instance_valid(player):
		target = player


func _on_eat_timer_timeout() -> void:
	eat()

func _on_shift_detector_shifted() -> void:
	var new_vendor = obj_vendor.instance()
	Game.replace_instance(self, new_vendor)

func _on_proceed_timer_timeout() -> void:
	proceed()
