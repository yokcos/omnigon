extends State


var target: Entity = null setget set_target
export (float) var speed = 100
export (float) var hover_distance = 32
export (String) var attack_state = "attacc"

var target_velocity: Vector2 = Vector2()


func _enter():
	._enter()
	
	father.can_flip = false

func _exit():
	._exit()
	
	father.reset_flippability()

func _step(delta: float):
	._step(delta)
	
	if is_instance_valid(target):
		var distance = target.global_position.distance_squared_to(father.global_position)
		var threshhold = hover_distance * hover_distance
		var direction = (target.global_position - father.global_position).angle()
		
		father.set_flip( father.global_position > target.global_position )
		
		if distance > threshhold:
			target_velocity = Vector2( speed, 0).rotated( direction )
		else:
			target_velocity = Vector2(-speed, 0).rotated( direction )
	else:
		target_velocity = Vector2()
	
	father.velocity = father.velocity.linear_interpolate(target_velocity, delta*5)

func perform_action(new_state: String):
	if active:
		set_state(new_state)


func set_target(what: Entity) -> void:
	target = what


