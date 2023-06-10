tool
extends Node2D


export (Color) var colour = Color("249fde") setget set_colour

func _ready() -> void:
	if !Engine.editor_hint:
		hide()
		queue_free()


func update_corners(size: Vector2, cell_size: Vector2 = Vector2(16, 16)):
	var extents = size/2 * cell_size
	
	$ul.position = -extents
	$br.position =  extents
	
	$ur.position = Vector2( extents.x,-extents.y )
	$bl.position = Vector2(-extents.x, extents.y )
	
	$ul.points = PoolVector2Array([
		Vector2(0, cell_size.y),
		Vector2(0, 0),
		Vector2(cell_size.x, 0),
	])
	$ur.points = PoolVector2Array([
		Vector2(0, cell_size.y),
		Vector2(0, 0),
		Vector2(-cell_size.x, 0),
	])
	$bl.points = PoolVector2Array([
		Vector2(0, -cell_size.y),
		Vector2(0, 0),
		Vector2(cell_size.x, 0),
	])
	$br.points = PoolVector2Array([
		Vector2(0, -cell_size.y),
		Vector2(0, 0),
		Vector2(-cell_size.x, 0),
	])

func set_colour(what: Color):
	colour = what
	
	for i in get_children():
		if i is Line2D:
			i.default_color = what
