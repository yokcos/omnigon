extends Area2D


var target: Node2D = null

var pupil_target: Vector2 = Vector2()
var pupil_distance: float = 6

var velocity: Vector2 = Vector2()
var acceleration: float = 100
var friction: float = 5

var default_value: float = 1
var value: float = default_value


func _ready():
	identify_target()
	
	var data = WorldSaver.load_data("savers")
	if data and data.has("vertices_collected"):
		value = default_value - data["vertices_collected"]

func _process(delta: float) -> void:
	nullify_target()
	identify_target()
	
	follow_target(delta)
	frictutate(delta)
	
	retarget_pupil()
	reposition_pupil(delta)
	
	if randf()*400 < 1:
		blink()
	
	position += velocity * delta


func nullify_target():
	if target and !is_instance_valid(target):
		target = null

func identify_target():
	if !target:
		var players: Array = get_tree().get_nodes_in_group("players")
		if players.size() > 0:
			target = players[0]

func get_target_direction() -> Vector2:
	if target:
		var direction = target.global_position - global_position
		return direction.normalized()
	else:
		return Vector2()

func follow_target(delta: float):
	if target:
		var direction = get_target_direction()
		
		velocity += direction * acceleration * delta

func frictutate(delta: float):
	velocity -= velocity * friction * delta

func retarget_pupil():
	if target:
		var direction = get_target_direction()
		
		pupil_target = direction * pupil_distance

func reposition_pupil(delta: float):
	$pupil.position = $pupil.position.linear_interpolate( pupil_target, delta*5 )

func blink():
	$animator.play("blink")

func teleport():
	var room_size: Vector2 = Rooms.room_size
	var margin: float = 64
	if Game.world:
		room_size *= Game.world.room_size
	
	var relative: Vector2 = Vector2( randf()*100, 0 ).rotated( randf()*PI*2 )
	var final_position = position + relative
	final_position.x = clamp(final_position.x, margin, room_size.x - margin)
	final_position.y = clamp(final_position.y, margin, room_size.y - margin)
	position = final_position

func get_shifted():
	if true or value > 0:
		var eye_boss = load("res://entities/enemies/eye_boss.tscn")
		var new_boss = eye_boss.instance()
		Game.replace_instance(self, new_boss)
	else:
		 queue_free()
