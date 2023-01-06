extends Area2D


var mode = 0

var particulations = [
	preload("res://fx/part_pot_fragment.tscn"),
	preload("res://fx/part_potb_fragment.tscn"),
]


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


func get_punched():
	queue_free()
	
	GlobalSound.play_random_sfx_2d(
		GlobalSound.sfx_pot_break_a if mode == 0 else GlobalSound.sfx_pot_break_b,
		global_position
	)
	
	var new_parts = particulations[mode].instance()
	Game.deploy_instance(new_parts, global_position)

func get_shifted():
	mode = 1 - mode
	
	update_sprite()
