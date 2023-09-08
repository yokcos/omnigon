extends Node


const cell_size: Vector2 = Vector2(16, 16)
const room_cell_count: Vector2 = Vector2(32, 16)
const colour: Color = Color("477d85")
const line_colour = Color("fa6a0a")
const invalid_colour = Color("403353")
const solid_tiles = [1, 3, 5, 7, 11]
const image_folder: String = "user://animations/room_image/"
const side_image_size: Vector2 = Vector2(256, 288)

var side_image: Image
var side_image_scale: int = 4
var current_frame: int = 0
var screenshot: Image
var main_size: Vector2
var combined_size: Vector2
var room: Node2D = null
var total_size: Vector2


func _ready() -> void:
	var map = load("res://rooms/map/main_map.tres")
	var this_room = map.map[ Vector2(3, 2) ]
	var new_room: Node2D = load(this_room).instance()
	add_child( new_room )
	room = new_room
	total_size = room_cell_count * room.room_size


func perform_operation():
	grab_screenshot()
	prepare_side_image()
	make_examination_animation(room)
	make_ladder_animation(room)
	get_tree().quit()

func grab_screenshot():
	var tex = get_viewport().get_texture()
	main_size = tex.get_size()
	combined_size = main_size
	combined_size.x += side_image_size.x
	screenshot = tex.get_data()
	screenshot.flip_y()

func prepare_side_image():
	side_image_size.y = screenshot.get_height()
	side_image = Image.new()
	side_image.create( side_image_size.x, side_image_size.y, false, Image.FORMAT_RGB8 )

func make_examination_animation( what: Node2D ):
	if !what.has_node("tilemap"):
		print("ERROR: No tilemap")
		return false
	
	var dir = Directory.new()
	if !dir.dir_exists(image_folder):
		dir.make_dir_recursive(image_folder)
	
	var tilemap: TileMap = what.get_node("tilemap")
	
	side_image.lock()
	for y in range(total_size.y):
		for x in range(total_size.x):
			var this_tile = tilemap.get_cell(x, y)
			if solid_tiles.has(this_tile):
				make_examination_frame(x, y)
	side_image.unlock()

func make_examination_frame(x: int, y: int):
	add_side_image_pixel(x, y)
	output_frame( PoolVector2Array([ Vector2(x, y) ]) )

func make_ladder_animation( what: Node2D ):
	var potential_ladders = Game.get_all_descendents(room)
	for this_ladder in potential_ladders:
		if !this_ladder.is_in_group("ladders"): continue
		if !room.is_a_parent_of(this_ladder): continue
		
		var pos: Vector2 = this_ladder.position
		var this_parent: Node = this_ladder.get_parent()
		while this_parent != room:
			pos += this_parent.position
			this_parent = this_parent.get_parent()
		
		side_image.lock()
		var ladder_cell_position: Vector2 = pos / cell_size
		for x in range(ladder_cell_position.x-1, ladder_cell_position.x+1):
			if x < 0: continue
			if x >= side_image.get_width(): continue
			for y in range(ladder_cell_position.y-1, ladder_cell_position.y-1 + this_ladder.length*2 + 1):
				if y < 0: continue
				if y >= side_image.get_height(): continue
				make_ladder_frame(x, y)
		side_image.unlock()

func make_ladder_frame(x: int, y: int):
	if y % 2 == 0:
		add_side_image_pixel(x, y)
	else:
		x = -x
	
	output_frame( PoolVector2Array([ Vector2(x, y) ]) )

func add_side_image_pixel(x: int, y: int):
	var image_centre: Vector2 = side_image_size/2
	var offset: Vector2 = Vector2(x, y) - total_size/2
	
	var pixel_start: Vector2 = image_centre + offset * side_image_scale
	for i in range(side_image_scale): for j in range(side_image_scale):
		var this_pos: Vector2 = pixel_start + Vector2(i, j)
		side_image.set_pixelv(this_pos, colour)

func output_frame(highlights: PoolVector2Array = PoolVector2Array()):
	var combined_image: Image = Image.new()
	combined_image.create( combined_size.x, combined_size.y, false, Image.FORMAT_RGB8 )
	combined_image.lock()
	combined_image.blit_rect( screenshot, Rect2(Vector2(), main_size), Vector2() )
	combined_image.blit_rect( side_image, Rect2(Vector2(), side_image_size), Vector2(main_size.x, 0) )
	
	for i in highlights:
		var cross: bool = false
		if i.x < 0:
			i.x = -i.x
			cross = true
			
		draw_pixel_connection( combined_image, i.x, i.y, cross )
	
	combined_image.unlock()
	combined_image.save_png( "%s_%04d.png" % [image_folder, current_frame] )
	current_frame += 1


func draw_pixel_connection( image: Image, x: int, y: int, cross: bool = false ):
	image.lock()
	
	var this_colour = invalid_colour if cross else line_colour
	var image_centre: Vector2 = side_image_size/2
	var offset: Vector2 = Vector2(x, y) - total_size/2
	var pixel_start: Vector2 = image_centre + offset * side_image_scale
	var line_start = Vector2(x, y) * cell_size + cell_size/2
	var line_end = pixel_start + Vector2(side_image_scale, side_image_scale)/2
	line_end.x += main_size.x
	draw_line( image, line_start, line_end, this_colour )
	
	var corners: PoolVector2Array = PoolVector2Array()
	for i in range(4):
		var this_angle: float = PI/4 + i*PI/2
		var base_vector: Vector2 = Vector2(cell_size.x*1.414213/2, 0)
		corners.append( line_start + base_vector.rotated(this_angle) )
	
	for i in range(4):
		draw_line(image, corners[i], corners[posmod(i+1, 4)], this_colour)
	
	if cross:
		draw_line(image, corners[0], corners[2], this_colour)
		draw_line(image, corners[1], corners[3], this_colour)
	
	image.unlock()

func draw_line(image: Image, from: Vector2, to: Vector2, this_colour: Color = line_colour):
	var dist: float = from.distance_to(to)
	var dir: Vector2 = (to-from).normalized()
	
	for i in range(dist):
		image.set_pixelv(from + dir*i, this_colour)

