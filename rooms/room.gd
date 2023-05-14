extends "res://world.gd"


export (String) var title = ""
export (Vector2) var room_size = Vector2(1, 1)
export (String) var music = ""
export (String) var temp_music = ""
export (Texture) var map_image = null
export (Color) var background_colour = Color("e3e6ff")

const obj_borders = preload("res://pieces/room_borders.tscn")


func _ready():
	var new_borders = obj_borders.instance()
	new_borders.room_size = room_size
	add_child(new_borders)
	load_tile_changes()
	
	if temp_music != "":
		GlobalSound.play_temp_music(temp_music)
		if music != "":
			PlayerStats.main_music = music
	else:
		if music == "":
			GlobalSound.resume_music()
		else:
			GlobalSound.play_music(music)
	
	WorldSaver.load_all_beings()
	WorldSaver.load_misc()
	
	VisualServer.set_default_clear_color(background_colour)
	Game.background_colour = background_colour


func load_tile_changes():
	var map = find_tile_map()
	var min_pos: Vector2 = Vector2(1000000, 1000000)
	var max_pos: Vector2 = Vector2()
	
	if map and WorldSaver.data.has(Rooms.current_room):
		for dict in WorldSaver.data[Rooms.current_room]:
			if dict is Dictionary and dict["type"] == "tile":
				var pos = dict["pos"]
				map.set_cellv(pos, dict["tile"], false, false, false, dict["subtile"])
				
				if pos.x < min_pos.x: min_pos.x = pos.x
				if pos.y < min_pos.y: min_pos.y = pos.y
				if pos.x > max_pos.x: max_pos.x = pos.x
				if pos.y > max_pos.y: max_pos.y = pos.y
		
		if min_pos.x < 1000000:
			map.update_bitmask_region(min_pos - Vector2(1, 1), max_pos + Vector2(1, 1))

func find_tile_map() -> TileMap:
	for i in get_children():
		if i is TileMap:
			return i
	return null


