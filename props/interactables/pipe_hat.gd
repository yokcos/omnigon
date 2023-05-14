extends "res://props/interactables/pipe.gd"


export (Resource) var hat = null

const obj_hat = preload("res://entities/hat.tscn")


func _ready() -> void:
	if hat and PlayerStats.available_hats.has(hat):
		$body/sprite.frame = 1
		$body/sprite_not.frame = 1
		active = false
		open = true
	
	description = "Pipe"
	verb = "Unseal"


func open_pipe():
	var result = .open_pipe()
	
	if result:
		var new_hat = obj_hat.instance()
		new_hat.set_hat(hat)
		var base_impulse: Vector2 = Vector2(0, rand_range(-800, -200)).rotated(rand_range(-.2, .2))
		new_hat.apply_central_impulse( base_impulse.rotated(global_rotation) )
		
		Game.deploy_instance(new_hat, global_position + Vector2(0, -16).rotated(global_rotation))
		
		WorldSaver.save_data( spawn_position, true )
		open = true


