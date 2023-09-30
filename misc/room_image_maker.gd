extends Node


const cell_size: Vector2 = Vector2(16, 16)
const room_cell_count: Vector2 = Vector2(32, 16)
const colours: Dictionary = {
	Color("e3e6ff"): Color("477d85"),
	Color("e4d2aa"): Color("5a4e44"),
	Color("f5a097"): Color("8e5252"),
	Color("8b93af"): Color("4a5462"),
}
const solid_tiles = [1, 3, 5, 7, 11]
const image_folder: String = "res://ui/map/images/"
const extra_image_folder: String = "res://ui/map/images/extra/"


func _ready() -> void:
	evaluate_all_rooms()

func evaluate_all_rooms():
	print("-------- -------- -------- -------- GENERATING ALL MAP IMAGES -------- -------- -------- --------")
	
	var dir = Directory.new()
	var map = load("res://rooms/map/main_map.tres")
	for i in map.map:
		var this_room = map.map[i]
		
		if this_room is Vector2:
			continue
		else:
			var new_room = load(this_room).instance()
			evaluate_room(new_room)
			new_room.queue_free()
	
	get_tree().quit()

func evaluate_room(what: Node2D):
	if !what.has_node("tilemap"):
		return false
	
	var this_colour: Color = Color()
	var valid_colour = false
	for i in colours.keys():
		if i.is_equal_approx(what.background_colour):
			this_colour = colours[i]
			valid_colour = true
			break
	if !valid_colour:
		print("%s not a real colour in room %s" % [what.background_colour.to_html(), what.filename])
		return false
	
	var tilemap: TileMap = what.get_node("tilemap")
	var total_size: Vector2 = room_cell_count * what.room_size
	
	var id: String = what.filename
	var last_slash = id.find_last("/")
	id = id.right(last_slash + 1)
	var dot = id.find(".")
	id = id.left(dot)
	
	var image: Image = Image.new()
	image.create(total_size.x, total_size.y, false, 5)
	image.lock()
	
	add_tile_pixels(image, tilemap, this_colour)
	add_extra_image(image, id)
	remove_corner_pixels(image)
	add_ladder_pixels(image, what, this_colour)
	
	image.unlock()
	
	var dir = Directory.new()
	if !dir.dir_exists(image_folder):
		dir.make_dir_recursive(image_folder)
	var image_path = "%s%s.png" % [image_folder, id]
	image.save_png(image_path)
	
	var tex = ImageTexture.new()
	tex.create_from_image(image, 0)
	what.map_image = tex
	var pck = PackedScene.new()
	pck.pack(what)
	var room_folder: String = "res://rooms/"
	ResourceSaver.save("%s%s.tscn" % [room_folder, id], pck)


func add_tile_pixels(image: Image, tilemap: TileMap, this_colour: Color):
	var total_size = image.get_size()
	
	for x in range(total_size.x):
		for y in range(total_size.y):
			#if x == 0 and y == 0: continue
			#if x == 0 and y == total_size.y-1: continue
			#if x == total_size.x-1 and y == 0: continue
			#if x == total_size.x - 1 and y == total_size.y - 1: continue
			
			var this_tile = tilemap.get_cell(x, y)
			if solid_tiles.has(this_tile):
				image.set_pixel(x, y, this_colour)

func add_ladder_pixels(image: Image, room: Node2D, this_colour: Color):
	var potential_ladders = Game.get_all_descendents(room)
	for this_ladder in potential_ladders:
		if !this_ladder.is_in_group("ladders"): continue
		if !room.is_a_parent_of(this_ladder): continue
		
		var pos: Vector2 = this_ladder.position
		var this_parent: Node = this_ladder.get_parent()
		while this_parent != room:
			pos += this_parent.position
			this_parent = this_parent.get_parent()
		
		var ladder_cell_position: Vector2 = pos / cell_size
		for x in range(ladder_cell_position.x-1, ladder_cell_position.x+1):
			if x < 0: continue
			if x >= image.get_width(): continue
			for y in range(ladder_cell_position.y-1, ladder_cell_position.y-1 + this_ladder.length*2 + 1):
				if y < 0: continue
				if y >= image.get_height(): continue
				if y % 2 == 0:
					image.set_pixel(x, y, this_colour)

func add_extra_image(image: Image, id: String):
	var checker = File.new()
	var image_file = "%s%s.png" % [extra_image_folder, id]
	if checker.file_exists(image_file):
		print("Found extra image of %s" % id)
		var tex: Texture = load(image_file)
		var extra_image: Image = tex.get_data()
		extra_image.lock()
		
		for x in range(image.get_width()):
			for y in range(image.get_height()):
				var new_pixel: Color = extra_image.get_pixel(x, y)
				if new_pixel == Color(0, 0, 0, 1):
					image.set_pixel(x, y, Color(0, 0, 0, 0))
				elif new_pixel.a > 0:
					image.set_pixel(x, y, new_pixel)
		
		extra_image.unlock()

func remove_corner_pixels(image: Image):
	var size: Vector2 = image.get_size()
	size -= Vector2(1, 1)
	
	for x in range(2):
		for y in range(2):
			var this_pixel: Vector2 = Vector2(x, y) * size
			var xcheck: int = 1 if x == 0 else -1
			var ycheck: int = 1 if y == 0 else -1
			
			if image.get_pixelv( this_pixel + Vector2(xcheck, 0) ).a < .5:
				continue
			if image.get_pixelv( this_pixel + Vector2(0, ycheck) ).a < .5:
				continue
			
			image.set_pixelv( this_pixel, Color(0, 0, 0, 0) )
