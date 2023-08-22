extends KinematicBody2D


var moneybags: Enemy = null
var can_jump: bool = true
var velocity: Vector2 = Vector2()
var jump_velocity: Vector2 = Vector2(300, 400)
var gravity: float = 1000
var binding_level: float = .2
var bound: bool = false
var line_droopyness: float = 10


func _ready() -> void:
	$jump_timer.wait_time = rand_range(3, 5)

func _process(delta: float) -> void:
	velocity.y += gravity*delta
	
	if $wall_detector.has_wall and velocity.y >= 0:
		velocity.y = 1
		velocity.x = lerp(velocity.x, 0, delta*5)
	
	if bound:
		update_line()

func _physics_process(delta: float) -> void:
	move_and_slide(velocity)


func identify_moneybags():
	if !is_instance_valid(moneybags):
		var mbs = get_tree().get_nodes_in_group("moneybagses")
		
		if mbs.size() > 0:
			moneybags = mbs[0]
			return true
		else:
			moneybags = null
			return false
	return true

func jump():
	if can_jump and identify_moneybags():
		var relative_position = moneybags.global_position - global_position
		velocity.x = sign( relative_position.x ) * jump_velocity.x
		velocity.y = -jump_velocity.y
		$sprite.flip_h = velocity.x < 0
		
		$animator.play("attacc")

func bind(what: Enemy):
	what.restrainedness += binding_level
	$line.show()
	bound = true

func update_line():
	if identify_moneybags():
		var relative_position = moneybags.global_position - global_position
		var points: PoolVector2Array = PoolVector2Array()
		var point_count: int = 16
		for i in range(point_count + 1):
			var ratio: float = float(i) / float(point_count)
			var this_downyness = - 4*ratio*ratio + 4*ratio
			this_downyness *= line_droopyness
			points.append( Vector2() + relative_position/point_count * i + Vector2(0, this_downyness) )
		$line.points = points


func _on_jump_timer_timeout() -> void:
	jump()

func _on_entity_detector_updated(entities) -> void:
	if !bound:
		for i in entities:
			if i == moneybags:
				bind(i)
