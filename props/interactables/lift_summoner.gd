extends Node2D


var obj_megalift = load("res://pieces/megalift_arriver.tscn")


func activate():
	var liftpos = WorldSaver.load_global_data("megalift_room")
	
	if liftpos:
		WorldSaver.save_global_data("megalift_room", Rooms.current_room)
		
		var new_megalift = obj_megalift.instance()
		Game.deploy_instance(new_megalift, global_position)
		if liftpos.y > Rooms.current_room.y:
			new_megalift.rise()
		else:
			new_megalift.sink()


func _on_interactable_activated() -> void:
	activate()
	$interactable.active = false
	$animator.play("depart")
