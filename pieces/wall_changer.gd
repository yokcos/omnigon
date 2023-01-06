tool
extends Node2D


var tile_size = Vector2(16, 16)

export (Vector2) var size = Vector2(2, 2) setget set_size
export (NodePath) var target_tiles = null
export (int) var change_to = -1
export (Vector2) var subtile = Vector2()
export (bool) var telekinetic = true # Whether it can affect tiles in other rooms
export (float) var delay = 0

var tiles: TileMap = null
var counting_down: bool = false
var time_till_change: float = delay


func _ready() -> void:
	if has_node(target_tiles):
		var these_tiles = get_node(target_tiles)
		if these_tiles is TileMap:
			tiles = get_node(target_tiles)
		else:
			print("Wall Changer Error: Target Tiles fails to be a TileMap")
	
	if !Engine.editor_hint:
		$visuals.hide()
		$visuals.queue_free()

func _process(delta: float) -> void:
	if counting_down:
		time_till_change -= delta
		
		if time_till_change <= 0:
			time_till_change = delay
			counting_down = false
			change_tiles()


func activate():
	if delay <= 0:
		change_tiles()
	else:
		time_till_change = delay
		counting_down = true

func change_tiles():
	if tiles:
		var start_pos = (global_position - tiles.global_position) / tile_size
		start_pos -= size/2
		
		for x in range(size.x):
			for y in range(size.y):
				change_tile(start_pos + Vector2(x, y))

func change_tile(where: Vector2):
	tiles.set_cellv(where, change_to, false, false, false, subtile)
	var data = form_tile_data(where)
	WorldSaver.save_room_data( data, true, Rooms.current_room )
	clear_mess()
	
	if telekinetic:
		change_tiles_telekinetically(where)

func change_tiles_telekinetically(where: Vector2):
	var room_pos: Vector2 = Rooms.current_room * Rooms.room_size
	var tile_centre: Vector2 = where*tile_size + tile_size/2 + room_pos
	
	# We need to check 9 times in order to transform 'border tiles'
	# that exist outside of the actual borders of the room
	var rooms = []
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			var new_centre: Vector2 = tile_centre + Vector2(x, y) * tile_size
			var this_room = Rooms.get_room_at(new_centre)
			if this_room != Rooms.current_room:
				if !rooms.has(this_room):
					rooms.append(this_room)
	
	for room in rooms:
		var tile_pos: Vector2 = tile_centre - room*Rooms.room_size
		tile_pos = (tile_pos / tile_size).floor()
		
		var data = form_tile_data(tile_pos)
		WorldSaver.save_room_data( data, true, room )

func form_tile_data(where: Vector2) -> Dictionary:
	return {
			"type": "tile",
			"pos": where,
			"tile": change_to,
			"subtile": subtile,
		}

func clear_mess():
	if tiles:
		var start_pos = global_position / tile_size
		start_pos -= size/2
		
		tiles.update_bitmask_region( start_pos - Vector2(1, 1), start_pos + size )

func update_corners():
	var extents = size/2 * tile_size
	
	$visuals/ul.position = -extents
	$visuals/br.position =  extents
	
	$visuals/ur.position = Vector2( extents.x,-extents.y )
	$visuals/bl.position = Vector2(-extents.x, extents.y )
	
	$visuals/ul.points = PoolVector2Array([
		Vector2(0, tile_size.y),
		Vector2(0, 0),
		Vector2(tile_size.x, 0),
	])
	$visuals/ur.points = PoolVector2Array([
		Vector2(0, tile_size.y),
		Vector2(0, 0),
		Vector2(-tile_size.x, 0),
	])
	$visuals/bl.points = PoolVector2Array([
		Vector2(0, -tile_size.y),
		Vector2(0, 0),
		Vector2(tile_size.x, 0),
	])
	$visuals/br.points = PoolVector2Array([
		Vector2(0, -tile_size.y),
		Vector2(0, 0),
		Vector2(-tile_size.x, 0),
	])

func set_size(what: Vector2):
	size = what
	update_corners()
