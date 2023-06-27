extends Button


export (Vector2) var destination = Vector2()
export (Vector2) var requirement = Vector2()


func _ready() -> void:
	update_visibility()

func _pressed() -> void:
	Rooms.player_enter_room(destination)


func update_visibility():
	var visits = WorldSaver.load_data_at(requirement, "visits")
	if visits == null or visits < 1:
		hide()
	else:
		show()
