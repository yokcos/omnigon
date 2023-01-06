tool
extends Node2D


var tile_size = Vector2(16, 16)

export (Vector2) var size = Vector2(2, 2) setget set_size
export (NodePath) var target_tiles = null
export (int) var check_tile = -1
export (bool) var check_all = false
export (bool) var use_subtile = false
export (Vector2) var subtile

var tiles: TileMap = null
var correct: bool = false


signal updated


func _ready() -> void:
	if has_node(target_tiles):
		var these_tiles = get_node(target_tiles)
		if these_tiles is TileMap:
			tiles = get_node(target_tiles)
			set_correct( check() )
			send_signal()
			tiles.connect("tile_changed", self, "_on_tiles_changed")
		else:
			print("Tile Detector Error: Target Tiles fails to be a TileMap")
	
	if !Engine.editor_hint:
		$visuals.hide()
		$visuals.queue_free()



func check():
	if tiles:
		var start_pos = (global_position - tiles.global_position) / tile_size
		start_pos -= size/2
		
		for x in range(size.x):
			for y in range(size.y):
				var this_pos = Vector2(x, y) + start_pos
				var this_tile = tiles.get_cellv(this_pos)
				var matches: bool = this_tile == check_tile
				var this_subtile = tiles.get_cell_autotile_coordv(this_pos)
				if use_subtile and this_subtile != subtile:
					matches = false
				if matches and !check_all:
					return true
				if !matches and check_all:
					return false
		
		return check_all
	return false

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

func send_signal():
	emit_signal("updated", correct)

func set_correct(what: bool):
	if correct != what:
		emit_signal("updated", what)
	correct = what

func set_size(what: Vector2):
	size = what
	update_corners()


func _on_tiles_changed(where: Vector2, tile: int):
	if tiles:
		var start_pos = (global_position - tiles.global_position) / tile_size
		start_pos -= size/2
		var relative = where - start_pos
		if relative.x < size.x and relative.y < size.y:
			if relative.x >= 0 and relative.y >= 0:
				set_correct( check() )
