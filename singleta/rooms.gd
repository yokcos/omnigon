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
var room_data: Dictionary = {}
var objects: Dictionary = {}
var pipe_images = {
	"res://props/interactables/pipe_vertices.gd": preload("res://ui/map/map_pipe_vertices.png"),
	"res://props/interactables/pipe_hat.gd": preload("res://ui/map/map_pipe_hat.png"),
	"res://props/interactables/pipe_lighter.gd": preload("res://ui/map/map_pipe_lighter.png"),
}

var map: Resource = null
const room_size = Vector2(512, 256)
const obj_player = preload("res://entities/player.tscn")


func _ready() -> void:
	load_rooms()

func _input(event: InputEvent) -> void:
	if false and !Engine.editor_hint and event.is_action_pressed("test") and Game.in_game:
		#player_enter_room(Vector2(256, 128))
		#skip_first_boss()
		player_enter_room(Vector2(-2200, 2400))
		
		PlayerStats.eyes = PlayerStats.EYES_SHAPESHIFTER


func skip_first_boss():
		player_enter_room(Vector2(-2700, -400))
		
		PlayerStats.eyes = PlayerStats.EYES_SHAPESHIFTER
		PlayerStats.gain_lighter(0)
		WorldSaver.save_room_data( Vector2(384, 200), true, Vector2(6, -4) )


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
			
			var room_descendents: Array = Game.get_all_descendents(new_room)
			for this_thing in room_descendents:
				log_object(i, new_room, this_thing)
					
			new_room.queue_free()

func log_object(room_pos: Vector2, room_node: Node, what: Node):
	if what is ArtisticCreation:
		var this_ancestor = what
		var artwork_position = Vector2()
		
		while this_ancestor != room_node and is_instance_valid(this_ancestor):
			artwork_position += this_ancestor.position
			this_ancestor = this_ancestor.get_parent()
		
		var tex: Texture = null
		var art_descendents: Array = Game.get_all_descendents(what)
		for potential_sprite in art_descendents:
			if potential_sprite is Sprite:
				tex = potential_sprite.texture
		
		artwork_position += room_pos * room_size
		
		if !objects.has("artistic_creations"):
			objects["artistic_creations"] = []
		objects["artistic_creations"].append( {
			"position": artwork_position,
			"texture": tex,
			"room": room_pos,
		} )
	
	if what is PipeInteractable:
		var this_ancestor = what
		var pipe_position = Vector2()
		
		while this_ancestor != room_node and is_instance_valid(this_ancestor):
			pipe_position += this_ancestor.position
			this_ancestor = this_ancestor.get_parent()
		var this_texture = null
		var this_script = what.get_script().get_path()
		if pipe_images.has(this_script):
			this_texture = pipe_images[this_script]
		
		pipe_position += room_pos * room_size
		if !objects.has("pipes"):
			objects["pipes"] = []
		objects["pipes"].append({
			"position": pipe_position,
			"texture": this_texture,
			"room": room_pos,
		})

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

func get_room_base(room_coords: Vector2) -> Vector2:
	# Gets the room-grid top-left coords of the given room
	# e.g. input (4, 6) is the bottom of a 3-tall room
	# will return (4, 4)
	if rooms.has(room_coords):
		while rooms[room_coords] is Vector2:
			room_coords = rooms[room_coords]
	
	return room_coords

func get_room_at(where: Vector2) -> Vector2:
	var room_pos = get_subroom_at(where)
	
	return get_room_base(room_pos)

func get_room_data(room_coords: Vector2):
	room_coords = get_room_base(room_coords)
	if room_data.has(room_coords):
		return room_data[ room_coords ]
	else:
		return null

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
