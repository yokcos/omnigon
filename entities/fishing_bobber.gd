extends Area2D


var source: Node2D = null
var target: Entity = null
var target_relative_position: Vector2 = Vector2()
var armed: bool = true

var velocity: Vector2 = Vector2()
var gravy: float = 540


func _process(delta: float) -> void:
	show_line()
	
	velocity.y += gravy * delta
	position += velocity * delta
	follow_target()


func follow_target():
	if is_instance_valid(target):
		global_position = target.global_position + target_relative_position

func show_line():
	if is_instance_valid(source):
		var point_count: int = 16
		var points: PoolVector2Array = PoolVector2Array()
		var relative: Vector2 = source.global_position - global_position
		var curve_depth: float = relative.length() / 5
		
		for i in range(point_count+1):
			var this_ratio: float = float(i) / float(point_count)
			var this_point = relative * this_ratio
			var downyness: float = 1 - pow(2*this_ratio - 1, 2)
			this_point.y += downyness * curve_depth
			points.append(this_point)
		
		$line.points = points
	else:
		$line.points = PoolVector2Array()


func _on_entity_detector_updated(entities: Array) -> void:
	if armed and entities.size() > 0:
		if entities[0] != source:
			armed = false
			velocity = Vector2()
			gravy = 0
			target = entities[0]
			target_relative_position = global_position - target.global_position

func _on_body_entered(body: Node) -> void:
	if armed:
		var prev_downyness: float = velocity.y
		velocity.y *= -.1
		if prev_downyness > 0 and velocity.y > -5000:
			velocity = Vector2()
			armed = false
			gravy = 0
