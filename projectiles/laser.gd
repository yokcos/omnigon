extends "res://pieces/hurtbox.gd"


export (Texture) var tex_start = preload("res://projectiles/laser0.png")
export (Texture) var tex_midst = preload("res://projectiles/laser1.png")
export (Texture) var tex_end   = preload("res://projectiles/laser2.png")

export (float) var animation_speed = 20
var actual_frame: float = 0
export (int) var frames = 8
export (bool) var random_frames = false

export (float) var max_length = 128
var length: float = max_length
var prev_length: float = length

const scr_autosprite = preload("res://pieces/auto_sprite.gd")


func _ready() -> void:
	deploy_sprites()
	resize_hitbox()
	$raycast.cast_to.x = max_length

func _process(delta: float) -> void:
	actual_frame += animation_speed * delta
	actual_frame = fposmod(actual_frame, frames)
	
	var dist: float
	if $raycast.is_colliding():
		dist = global_position.distance_to($raycast.get_collision_point())
	else:
		dist = max_length
	if abs(dist - length) > 2:
		length = dist
		deploy_sprites() 
		resize_hitbox()


func clear_sprites():
	for i in $sprites.get_children():
		if i is Sprite:
			i.queue_free()
	for i in $sprites/midst.get_children():
		if i is Sprite:
			i.queue_free()

func deploy_sprites():
	clear_sprites()
	
	var total_length = 0
	var tex_width: float = tex_start.get_width() / frames
	var new_sprite: Sprite
	
	# Create the first sprite if there is enough space
	if tex_width <= length:
		new_sprite = create_sprite(tex_start)
		$sprites.add_child(new_sprite)
		new_sprite.position.x = tex_width/2
		total_length += tex_width
	
	# Continually create the middle sprite while there is enough space
	tex_width = tex_midst.get_width() / frames
	while total_length <= length - tex_width:
		new_sprite = create_sprite(tex_midst)
		$sprites/midst.add_child(new_sprite)
		new_sprite.position.x = total_length + tex_width/2
		total_length += tex_width
	
	# Create the remainder middle sprite
	if total_length <= length - 1:
		var remainder = length - total_length
		new_sprite = create_remainder_sprite(remainder)
		$sprites/midst.add_child(new_sprite)
		new_sprite.position.x = (total_length + length)/2
		total_length = length
	
	# Unconditionally create the end sprite
	tex_width = tex_end.get_width() / frames
	new_sprite = create_sprite(tex_end)
	$sprites.add_child(new_sprite)
	new_sprite.position.x = length - tex_width/2

func resize_hitbox():
	$hitbox.shape.extents.x = length/2
	$hitbox.position.x = length/2

func create_remainder_sprite(remainder: float) -> Sprite:
	var width = int(remainder)
	var new_texture: ImageTexture = ImageTexture.new()
	var height: int = tex_midst.get_height()
	var old_width: int = tex_midst.get_width()
	var old_image: Image = tex_midst.get_data()
	var final_image: Image = Image.new()
	var src_rect = Rect2( 0, 0, width, height )
	final_image.create(width * frames, height, false, Image.FORMAT_RGBA8)
	
	for i in range(frames):
		src_rect.position.x = i * old_width / frames
		final_image.blit_rect( old_image, src_rect, Vector2(width*i, 0) )
	
	new_texture.create_from_image(final_image, 2)
	
	return create_sprite(new_texture)

func create_sprite(tex: Texture) -> Sprite:
	var new_sprite = Sprite.new()
	new_sprite.texture = tex
	new_sprite.set_script(scr_autosprite)
	new_sprite.animation_speed = animation_speed
	new_sprite.hframes = frames
	
	if random_frames:
		new_sprite.actual_frame = randf() * frames
	else:
		new_sprite.actual_frame = actual_frame
	new_sprite.frame = int(new_sprite.actual_frame)
	
	return new_sprite
