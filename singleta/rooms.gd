tool
extends Node


var current_room: Vector2 = Vector2()
var rooms: Dictionary = {
	Vector2( 0, 0): preload("res://rooms/start.tscn"),
	Vector2( 1, 0): preload("res://rooms/second.tscn"),
	Vector2( 2,-1): preload("res://rooms/junction1.tscn"),
	Vector2( 2, 0): Vector2( 2,-1),
	Vector2( 3, 0): preload("res://rooms/pitfall.tscn"),
	Vector2( 3, 1): preload("res://rooms/shapeshifter.tscn"),
	Vector2( 3, 2): preload("res://rooms/do_not_feed.tscn"),
	Vector2( 4,-1): preload("res://rooms/adepts.tscn"),
	Vector2( 4, 0): Vector2(4,-1),
	Vector2( 4, 1): Vector2(4,-1),
	Vector2( 5, 0): preload("res://rooms/deathbutton.tscn"),
	Vector2( 4,-2): preload("res://rooms/corners.tscn"),
	Vector2( 3,-2): preload("res://rooms/nofloor.tscn"),
	Vector2( 3,-1): Vector2(3,-2),
	Vector2( 2,-2): preload("res://rooms/junction0.tscn"),
	Vector2( 1,-2): preload("res://rooms/spikefloor.tscn"),
	Vector2( 0,-2): preload("res://rooms/overstart.tscn"),
	Vector2( 0,-1): preload("res://rooms/overstartB.tscn"),
	Vector2(-2, 0): preload("res://rooms/warning.tscn"),
	Vector2(-1, 0): Vector2(-2, 0),
	Vector2(-3, 0): preload("res://rooms/eye_room.tscn"),
	Vector2(-4, 0): preload("res://rooms/aghastor.tscn"),
	Vector2(-5, 0): preload("res://rooms/arena.tscn"),
	Vector2(-6,-1): preload("res://rooms/megaladder.tscn"),
	Vector2(-6, 0): Vector2(-6,-1),
	Vector2(-6, 1): Vector2(-6,-1),
}
var room_data: Dictionary = {
	
}

var map: Resource = null
const room_size = Vector2(512, 256)
const obj_player = preload("res://entities/player.tscn")


func _ready() -> void:
	load_rooms()

func _input(event: InputEvent) -> void:
	if !Engine.editor_hint and event.is_action_pressed("test") and Game.in_game:
		#player_enter_room(Vector2(256, 128))
		player_enter_room(Vector2(-7100, 800))
		PlayerStats.eyes = PlayerStats.EYES_SHAPESHIFTER


func enter_game():
	Game.in_game = true

func load_rooms():
	apply_fresh_map()
	
	rooms = {}
	
	var dir = Directory.new()
	map = load("res://rooms/map/main_map.tres")
	for i in map.map:
		var this_room = map.map[i]
		
		if this_room is Vector2:
			rooms[i] = this_room
		else:
			room_data[i] = {}
			rooms[i] = load(this_room)
			
			var new_room = rooms[i].instance()
			room_data[i]["title"] = new_room.title
			room_data[i]["image"] = new_room.map_image
			new_room.queue_free()

func apply_fresh_map():
	var fresh_path: String = "res://rooms/map/fresh_map.tres"
	
	var dir = Directory.new()
	if dir.file_exists(fresh_path):
		var fresh_map = load(fresh_path)
		ResourceSaver.save( "res://rooms/map/main_map.tres", fresh_map )
		dir.remove(fresh_path)

func print_rooms():
	var dict = {}
	for i in rooms:
		var this_room = rooms[i]
		if this_room is Vector2:
			dict[i] = this_room
		else:
			dict[i] = this_room.instance().name
	
	print(dict)

func get_room_at(where: Vector2) -> Vector2:
	var room_pos = get_subroom_at(where)
	
	if rooms.has(room_pos):
		while rooms[room_pos] is Vector2:
			room_pos = rooms[room_pos]
	
	return room_pos

func get_subroom_at(where: Vector2) -> Vector2:
	var room_pos = where / room_size
	room_pos = room_pos.floor()
	
	return room_pos

func get_world_position(what: Vector2) -> Vector2:
	return what + room_size * current_room

func get_room_size(where: Vector2) -> Vector2:
	var maximum: Vector2 = where
	for i in rooms.keys():
		var pos = rooms[i]
		if pos is Vector2 and pos == where:
			maximum.x = max(maximum.x, i.x)
			maximum.y = max(maximum.y, i.y)
	
	return (maximum-where) + Vector2(1, 1)

func enter_room(which: Vector2) -> bool:
	which = which.floor()
	if rooms.has(which):
		var target = rooms[which]
		if target is Vector2:
			# For large rooms
			return enter_room(target)
		else:
			# The actual function
			if Game.in_game:
				WorldSaver.save_room()
			else:
				call_deferred("enter_game")
			Game.save_game()
			current_room = which
			Game.switch_room( target )
			WorldSaver.add_data("visits", 1)
			return true
	
	return false

func player_enter_room(pos: Vector2):
	var room_pos = pos / room_size
	room_pos = room_pos.floor()
	
	if enter_room(room_pos):
		call_deferred("replace_player", pos)

func replace_player(global_pos: Vector2):
	destroy_player()
	deploy_player(global_pos)

func destroy_player():
	for player in get_tree().get_nodes_in_group("players"):
		player.queue_free()

func deploy_player(global_pos: Vector2):
	var room_pos = (global_pos/room_size).floor()
	var new_player = obj_player.instance()
	Game.deploy_instance(new_player, global_pos - current_room*room_size)
