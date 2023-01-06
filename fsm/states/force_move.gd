extends State


export (String) var still_animation = "idle"
export (String) var run_animation = "run"

export (Vector2) var target_position = Vector2()

export (int) var direction_to_face = 0


var stage: int = 0

var stopping_distance: float = 9


func _ready() -> void:
	direction_to_face = sign(direction_to_face)


func _enter():
	._enter()
	
	stage = 0

func _step(delta: float):
	._step(delta)
	
	var animator = get_animator()
	
	match stage:
		0:
			accelerate(delta)
			if abs(father.global_position.x - target_position.x) < stopping_distance:
				stage = 1
			
			if animator:
				animator.play(run_animation)
		1:
			decelerate(delta)
			if abs(father.velocity.x) < 3:
				stage = 2
			
			if animator:
				animator.play(still_animation)
		2:
			if sign(father.velocity.x) == direction_to_face or direction_to_face == 0:
				stage = 3
			else:
				father.accelerate(direction_to_face, delta)
		3:
			set_state(auto_proceed)


func accelerate(delta: float):
	if father.global_position.x < target_position.x:
		father.accelerate( 1, delta)
	if father.global_position.x > target_position.x:
		father.accelerate(-1, delta)

func decelerate(delta: float):
	if father.velocity.x < 0:
		father.accelerate( 1, delta)
	if father.velocity.x > 0:
		father.accelerate(-1, delta)

func apply_animation():
	var animator = get_animator()
	if animator:
		if abs(father.velocity.x) > 10:
			animator.play(run_animation)
		else:
			animator.play(still_animation)

