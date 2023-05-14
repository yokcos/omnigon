extends "res://props/interactables/pipe.gd"


export (PackedScene) var object = null
export (String) var upgrade = ""


func _ready() -> void:
	if upgrade != "" and PlayerStats.check_upgrade(upgrade):
		$body/sprite.frame = 1
		$body/sprite_not.frame = 1
		active = false
	
	description = "Pipe"
	verb = "Unseal"


func open_pipe():
	var result = .open_pipe()
	
	if result:
		var new_thing = object.instance()
		Game.deploy_instance(new_thing, global_position + Vector2(0, -16).rotated(global_rotation))
		
		var base_impulse: Vector2 = Vector2(0, rand_range(-800, -200)).rotated(rand_range(-.2, .2))
		if new_thing is RigidBody2D:
			new_thing.apply_central_impulse(base_impulse.rotated(global_rotation))


