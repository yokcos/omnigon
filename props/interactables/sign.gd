extends TextInteractable


func _on_shift() -> void:
	var obj_thing = load("res://props/interactables/speaker.tscn")
	var new_thing = obj_thing.instance()
	
	new_thing.sign_title = title
	new_thing.sign_text = text
	new_thing.sign_egress = egress
	
	new_thing.sign_highlight_distance = highlight_distance
	new_thing.sign_description = description
	new_thing.sign_verb = verb
	new_thing.sign_thru_walls = thru_walls
	
	Game.deploy_instance(new_thing, global_position)
	queue_free()
