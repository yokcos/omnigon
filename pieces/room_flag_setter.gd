extends Node


export (Vector2) var room = Vector2()
export (int) var flag = 0
export (bool) var value = true


func activate():
	var existing_flags = WorldSaver.load_data_at(room, "image_flags")
	var flags: Array = []
	
	if existing_flags is Array:
		flags = existing_flags
	
	while flags.size() <= flag:
		flags.append(false)
	
	flags[flag] = value
	
	WorldSaver.save_room_data("image_flags", flags, room)
	Rooms.apply_room_image(room)
