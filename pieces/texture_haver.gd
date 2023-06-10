tool
extends Node2D


export (Vector2) var size = Vector2(2, 2) setget set_size
export (String) var texture_id = ""
export (bool) var delete_on_room_change = true

var cell_size: Vector2 = Vector2(16, 16)
var pos: Vector2 = Vector2()
var tex: WorldTexture = null setget set_tex


func _ready() -> void:
	if tex == null and !Engine.editor_hint:
		register_texture()
	#Game.connect("world_changed", self, "_on_world_changed")



func register_texture():
	var valid_havers: Array = []
	
	for i in get_tree().get_nodes_in_group("texture_havers"):
		if i.texture_id == texture_id:
			valid_havers.append(i)
	
	var toppest:   float = 1000000
	var leftest:   float = 1000000
	var bottomest: float = -1000000
	var rightest:  float = -1000000
	
	for this_haver in valid_havers:
		var this_topleft:     Vector2 = this_haver.global_position - this_haver.size/2 * cell_size
		var this_bottomright: Vector2 = this_haver.global_position + this_haver.size/2 * cell_size
		
		if this_topleft.y < toppest:
			toppest = this_topleft.y
		if this_topleft.x < leftest:
			leftest = this_topleft.x
		if this_bottomright.y > bottomest:
			bottomest = this_bottomright.y
		if this_bottomright.x > rightest:
			rightest  = this_bottomright.x
	
	var img = Image.new()
	var width: int = int( rightest - leftest )
	var height: int = int( bottomest - toppest )
	img.create( width, height, false, Image.FORMAT_RGBA8 )
	
	tex = WorldTexture.new()
	tex.create_from_image( img, 0 )
	tex.position = Vector2( leftest, toppest )
	
	for this_haver in valid_havers:
		var this_topleft: Vector2 = this_haver.global_position - this_haver.size/2 * cell_size
		
		this_haver.tex = tex
		this_haver.pos = this_topleft - Vector2(leftest, toppest)

func update_corners():
	$visuals.update_corners(size, cell_size)

func update_sprite():
	$sprite.region_rect.size = size * cell_size


func set_size(what: Vector2):
	size = what
	
	call_deferred("update_corners")
	call_deferred("update_sprite")

func set_tex(what: WorldTexture):
	tex = what
	$sprite.texture = what
	$sprite.region_rect.position = global_position - what.position - size*cell_size/2

func _on_world_changed(world):
	if delete_on_room_change:
		tex.free()

