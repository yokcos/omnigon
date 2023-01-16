tool
extends Node2D


export (String) var map_name = "fresh_map"
export (Vector2) var room_size = Vector2(512, 256)
export (bool) var activate = false setget set_activate

var rooms: Dictionary = {}


func register_rooms():
	var path: String = "res://rooms/map/%s.tres" % map_name
	var dir = Directory.new()
	dir.remove(path)
	
	for room in get_children():
		var pos: Vector2 = (room.position / Rooms.room_size).round()
		rooms[pos] = room.filename
		
		for i in room.room_size.x:
			for j in room.room_size.y:
				var relative = Vector2(i, j)
				if relative != Vector2():
					rooms[pos + relative] = pos
	
	var new_map = WorldMap.new()
	new_map.map = rooms
	
	ResourceSaver.save(path, new_map, 6)


func set_activate(what: bool):
	register_rooms()
