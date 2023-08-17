extends State


export (String) var still_animation = "idle"
export (String) var run_animation = "run"

export (float) var turn_delay = 1

var has_edge: bool = true
var direction: float = -1
# Time at which the thing will exit a 'turning around' substate
var turn_time: float = 0


func _enter() -> void:
	._enter()
	call_deferred("update_flip")
	turn_time = age + 0.5

func _step(delta: float) -> void:
	._step(delta)
	
	move_normally(delta)


func move_normally(delta: float):
	if is_time_now(turn_time - 0.8, delta) and father.is_grounded():
		update_flip()
		father.velocity.x = 0
	
	if age >= turn_time:
		if has_edge:
			turn()
		else:
			father.accelerate(direction, delta)
	
	var animator = get_animator()
	if animator:
		if abs(father.velocity.x) > 10:
			animator.play(run_animation)
		else:
			animator.play(still_animation)

func turn():
	if active:
		turn_time = turn_delay + age
		direction = -father.flip_int

func update_flip():
	if father.flip_int != direction:
		father.invert_flip()

func perform_action(new_state: String):
	if active:
		set_state(new_state)
		return true
	return false

func perform_action_random(new_states: Array):
	if new_states.size() > 0:
		new_states.shuffle()
		perform_action(new_states[0])


func _on_walledge_detector_updated(what: bool):
	has_edge = what


