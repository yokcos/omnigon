extends "res://rooms/room.gd"


var previous_activations: int = false

const obj_vertex = preload("res://entities/vertex.tscn")


func _ready() -> void:
	# PRESSES can be NULL, but we want an integer. Hence the use of two variables and this comparison to 0
	var presses = WorldSaver.load_data($button.global_position)
	if presses == null:
		previous_activations = 0
	else:
		previous_activations = presses
	$button.previous_activations = previous_activations
	$button.change_text()


func kill():
	$animator.play("kill")


func _on_button_activated() -> void:
	if previous_activations == 0:
		kill()
		
		previous_activations += 1
		WorldSaver.save_data($button.global_position, previous_activations)
	elif previous_activations == 1:
		for i in range(15):
			var new_vertex = obj_vertex.instance()
			var base_impulse: Vector2 = Vector2(0, rand_range(-800, -200)).rotated(rand_range(-.2, .2))
			new_vertex.apply_central_impulse( base_impulse.rotated(global_rotation) )
			
			Game.deploy_instance(new_vertex, $button.global_position + Vector2(0, -16))
			
		previous_activations += 1
		WorldSaver.save_data($button.global_position, previous_activations)
	
	$button.previous_activations = previous_activations
	$button.change_text()
