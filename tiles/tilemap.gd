extends TileMap


signal tile_changed


func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2()):
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	emit_signal("tile_changed", Vector2(x, y), tile)

func set_cellv(where: Vector2, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2()):
	.set_cellv(where, tile, flip_x, flip_y, transpose, autotile_coord)
	emit_signal("tile_changed", where, tile)

func get_cell_autotile_coordv(where: Vector2):
	return get_cell_autotile_coord(int(where.x), int(where.y))
