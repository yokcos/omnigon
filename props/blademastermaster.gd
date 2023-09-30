extends "res://props/animator_haver.gd"


export (bool) var floorbound = true

var target: Node2D = null setget set_target

const obj_hat = preload("res://entities/hat.tscn")
const hat_mb = preload("res://hats/0013_moneybag.tres")


func _ready() -> void:
	if floorbound:
		go_to_floor()
	
	Events.connect("moneybags_ended", self, "_on_moneybags_ended")


func go_to_floor():
	$floor_finder.force_raycast_update()
	if $floor_finder.is_colliding():
		var floor_pos = $floor_finder.get_collision_point()
		var height_above_floor: float = 16
		
		position = floor_pos - Vector2(0, height_above_floor)
	$floor_finder.enabled = false

func set_target(what: Node2D):
	target = what

func smack_target():
	var animdur = .2
	
	$tween.interpolate_property(
		self, "global_position",
		global_position, target.global_position, animdur,
		Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	$tween.interpolate_callback(
		self, animdur, "perform_smack"
	)
	$tween.interpolate_callback(
		self, animdur, "unenlighten"
	)
	$tween.interpolate_property(
		self, "global_position",
		target.global_position, global_position, animdur,
		Tween.TRANS_CUBIC, Tween.EASE_OUT, animdur
	)
	$tween.start()

func perform_smack():
	GlobalSound.play_random_sfx(GlobalSound.sfx_bouncer_bounce)
	
	if !PlayerStats.has_available_hat("moneybag"):
		var new_hat = obj_hat.instance()
		new_hat.hat = hat_mb
		Game.deploy_instance(new_hat, global_position)
		new_hat.apply_central_impulse( Vector2(0, -600).rotated(rand_range(-.5, .5)) )
	
	var player = Game.get_player()
	if is_instance_valid(player):
		player.long_stun()

func unenlighten():
	$enlightenment.hide()


func _on_moneybags_ended():
	if floorbound:
		$interactable.active = true
