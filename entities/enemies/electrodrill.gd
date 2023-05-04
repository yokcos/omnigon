extends Enemy


export (float) var target_longitude = 0
export (float) var blockade_duration = 10
export (bool) var ceilingborne = true

var can_shoot: bool = false
var obj_gigamanner = load("res://entities/enemies/gigamanner.tscn")


func _ready() -> void:
	$fsm/extended.duration = blockade_duration
	
	if ceilingborne:
		snap_to_ceiling()
		$fsm.set_state_string("idle")
	
	extra_data["target_longitude"] = target_longitude
	extra_data["blockade_duration"] = blockade_duration

func _process(delta: float) -> void:
	var floor_position: float = $ground_finder.get_collision_point().y
	$flippable/head1.global_position.y = floor_position - 8
	
	var connection_length = (floor_position - global_position.y) - 24
	$flippable/connection.region_rect.size.y = connection_length
	$flippable/connection.position.y = 8 + connection_length/2
	$hurtbox/hitbox.shape.extents.y = connection_length/2
	$hurtbox.position.y = 8 + connection_length/2
	$blockade/hitbox.shape.extents.y = connection_length/2
	$blockade.position.y = 8 + connection_length/2
	
	if abs(global_position.x - target_longitude) < 8:
		if can_shoot or global_position.x == target_longitude:
			$fsm/idle.set_state("preextend")
	else:
		can_shoot = true


func get_loaded(data):
	if data:
		.get_loaded(data)
		
		if data.has("target_longitude"):
			target_longitude = data["target_longitude"]
		if data.has("blockade_duration"):
			blockade_duration = data["blockade_duration"]

func snap_to_ceiling():
	$ceiling_finder.force_raycast_update()
	var ceiling_position: float = $ceiling_finder.get_collision_point().y
	global_position.y = ceiling_position + 8

func activate_hurtbox():
	$hurtbox.active = true

func deactivate_hurtbox():
	$hurtbox.active = false

func extend():
	$flippable/head0.hide()
	$flippable/head1.show()
	$flippable/connection.show()
	$blockade/hitbox.disabled = false
	
	activate_hurtbox()
	deploy_upper_sparks()
	deploy_lower_sparks()
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_electrodrill_impact, $flippable/head1.global_position)

func unextend():
	$flippable/head0.show()
	$flippable/head1.hide()
	$flippable/connection.hide()
	$blockade/hitbox.disabled = true
	
	deactivate_hurtbox()
	snap_to_ceiling()
	deploy_upper_sparks()
	$whoosh.show()
	$unwhoosher.start()
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_electrodrill_unextend, global_position)

func deploy_upper_sparks():
	var pos = global_position + Vector2(0, 40)
	var new_fx = Game.deploy_fx( load("res://fx/drill_spark.png"), pos, 8 )
	new_fx.scale.y = -1

func deploy_lower_sparks():
	var pos = $flippable/head1.global_position + Vector2(0, -16)
	Game.deploy_fx( load("res://fx/drill_spark.png"), pos, 8 )

func get_shifted():
	var new_gigamanner = obj_gigamanner.instance()
	new_gigamanner.target_longitude = target_longitude
	new_gigamanner.blockade_duration = blockade_duration
	Game.replace_instance(self, new_gigamanner)
	
	var above_clearance = global_position.y - $ceiling_finder.get_collision_point().y
	if above_clearance < 32:
		var below_clearance = $ground_finder.get_collision_point().y - global_position.y
		if above_clearance + below_clearance < 40:
			var timer = get_tree().create_timer(.5)
			timer.connect("timeout", new_gigamanner, "get_shifted")
		else:
			new_gigamanner.position.y += 24


func _on_idle_entered() -> void:
	can_shoot = false
	$fsm/idle.direction = sign(target_longitude - global_position.x)

func _on_unwhoosher_timeout() -> void:
	$whoosh.hide()

func _on_extended_entered() -> void:
	extend()

func _on_unextend_entered() -> void:
	unextend()
