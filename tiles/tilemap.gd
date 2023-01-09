extends TileMap


var randomisers: Array = []

signal tile_changed


func _ready() -> void:
	get_randomisers()
	randomise_tiles()


func get_randomisers():
	randomisers = []
	var dir = Directory.new()
	var path: String = "res://tiles/randomisers/"
	dir.open(path)
	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname != "":
		
		if !dir.current_is_dir():
			var this_thing = load(path + fname)
			if this_thing is TileRandomiser:
				randomisers.append(this_thing)
		
		fname = dir.get_next()

func randomise_tiles():
	for i in randomisers:
		apply_randomiser(i)

func apply_randomiser(tra: TileRandomiser):
	for cell in get_used_cells_by_id(tra.tile_id):
		var original_subtile: Vector2 = get_cell_autotile_coord(cell.x, cell.y)
		if tra.subtiles.has(original_subtile):
			var index: int = randi() % tra.subtiles.size()
			var flip_x: bool = is_cell_x_flipped(cell.x, cell.y)
			var flip_y: bool = is_cell_y_flipped(cell.x, cell.y)
			var transpose: bool = is_cell_transposed(cell.x, cell.y)
			set_cellv(cell, tra.tile_id, flip_x, flip_y, transpose, tra.subtiles[index])


func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2()):
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	emit_signal("tile_changed", Vector2(x, y), tile)

func set_cellv(where: Vector2, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2()):
	.set_cellv(where, tile, flip_x, flip_y, transpose, autotile_coord)
	emit_signal("tile_changed", where, tile)

func get_cell_autotile_coordv(where: Vector2):
	return get_cell_autotile_coord(int(where.x), int(where.y))
