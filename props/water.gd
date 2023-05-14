tool
extends Area2D


export (Vector2) var size = Vector2(1, 1) setget set_size

var cell_size: Vector2 = Vector2(16, 16)


func _ready() -> void:
	create_texture()


func create_texture():
	var osn = OpenSimplexNoise.new()
	var img: Image
	var tex: ImageTexture = ImageTexture.new()
	osn.seed = 1
	img = osn.get_seamless_image(512)
	tex.create_from_image(img)
	$sprite.material.set_shader_param("noise0", tex)
	osn.seed = 1
	img = osn.get_seamless_image(512)
	tex.create_from_image(img)
	$sprite.material.set_shader_param("noise1", tex)


func set_size(what: Vector2):
	size = what
	
	var halfsize = what * cell_size / 2
	var fullsize = halfsize*2
	$sprite.region_rect.size = fullsize
	
	var img = Image.new()
	img.create( fullsize.x, fullsize.y, false, Image.FORMAT_RGBA4444 )
	img.fill(Color(0, 0, 0, 0))
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	$sprite.texture = tex
	
	var new_shape: RectangleShape2D = RectangleShape2D.new()
	new_shape.extents = halfsize
	$hitbox.shape = new_shape
