extends Area2D


var mode = 0


const obj_blademaster = preload("res://entities/enemies/blademaster.tscn")


func _ready() -> void:
	add_to_group("saveables")


func get_saved():
	return {
		"mode": mode
	}

func get_loaded(what: Dictionary):
	mode = what["mode"]
	
	update_sprite()

func update_sprite():
	$sprite.visible  = mode == 0
	$spriteb.visible = mode == 1


func get_shifted():
	if mode == 0:
		mode = 1
		
		update_sprite()
		
		var new_blademaster = obj_blademaster.instance()
		new_blademaster.velocity = Vector2(-200, -400) * scale
		Game.deploy_instance(new_blademaster, $barrel.global_position)
