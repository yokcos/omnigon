extends Area2D


var source: Node2D = null
var target: Entity = null
var target_relative_position: Vector2 = Vector2()
var armed: bool = true
var waters: Array = []

var velocity: Vector2 = Vector2()
var gravy: float = 540
var knockback = 200

const obj_fishticuffs = preload("res://fishticuffs/fishticuffs_holder.tscn")


func _process(delta: float) -> void:
	show_line()
	
	if waters.size() <= 0:
		velocity.y += gravy * delta
	else:
		velocity.y -= gravy * delta * .5
		velocity -= velocity * delta * 5
	position += velocity * delta
	follow_target()


func attach_to_target(what: Being):
	target = what
	target.connect("tree_exiting", self, "_on_target_slain")
	target_relative_position = global_position - target.global_position
	what.take_damage(.75, source)
	what.take_knockback( -target_relative_position.normalized() * knockback )

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

func deactivate():
	velocity = Vector2()
	armed = false
	gravy = 0


func _on_entity_detector_updated(entities: Array) -> void:
	if armed and entities.size() > 0:
		if entities[0] != source:
			armed = false
			velocity = Vector2()
			gravy = 0
			attach_to_target( entities[0] )

func _on_body_entered(body: Node) -> void:
	if armed:
		if body.has_method("get_punched"):
			body.get_punched()
		
		if $over_detector.overlaps_body(body):
			deactivate()
		else:
			var prev_downyness: float = velocity.y
			velocity.y *= -.1
			if prev_downyness > 0 and velocity.y > -5000:
				velocity = Vector2()
				armed = false
				gravy = 0

func _on_area_entered(area: Area2D) -> void:
	if armed and area.has_method("get_punched"):
		area.get_punched()
	
	if area.is_in_group("waters"):
		if !is_instance_valid(Game.current_popup):
			queue_free()
			var new_fc = obj_fishticuffs.instance()
			Game.call_deferred("deploy_ui_instance", new_fc, Vector2())
		else:
			if !waters.has(area):
				waters.append(area)
				GlobalSound.play_random_sfx_2d( GlobalSound.sfx_splash, global_position )

func _on_area_exited(area: Area2D) -> void:
	if waters.has(area):
		waters.erase(area)

func _on_target_slain():
	if is_instance_valid(source):
		source.recall_bobber()
	else:
		queue_free()
