extends Control


var age: float = 0
var phase_offset = randf() * 20
var actual_position: Vector2 = Vector2()
var holder: Control = null
var indicant_line: Line2D = null
var image: TextureRect = null
var base_image_scale: Vector2 = Vector2(1, 1)
var target_size: Vector2 = Vector2(48, 48)
var edgebound: bool = true


func _ready():
	if edgebound:
		deploy_indicant_line()

func _process(delta: float) -> void:
	age += delta
	
	transform_image()
	if edgebound:
		go_to_edge()
		update_indicant_line()
	else:
		rect_position = actual_position


func transform_image():
	if is_instance_valid(image):
		image.rect_rotation = 10*sin(age + phase_offset / 3)
		var size: float = .4 + .1*cos(age - phase_offset / 1.1)
		image.rect_scale = Vector2(size, .8-size) * base_image_scale

func deploy_indicant_line():
	indicant_line = Line2D.new()
	indicant_line.default_color = Color("403353")
	indicant_line.points = PoolVector2Array([Vector2(), Vector2()])
	indicant_line.width = 1
	add_child(indicant_line)

func update_indicant_line():
	if is_instance_valid(indicant_line):
		indicant_line.points[1] = (actual_position - rect_position)

func go_to_edge():
	if is_instance_valid(holder):
		var holder_centre: Vector2 = holder.rect_size/2
		var this_position: Vector2 = actual_position + get_parent().rect_position
		var position_from_centre: Vector2 = (this_position - holder_centre)
		
		if position_from_centre.length_squared() <= 250*250:
			show()
			position_from_centre = position_from_centre.normalized() * 250
			var limits: Vector2 = holder.rect_size/2 - Vector2(16, 16)
			position_from_centre.x = clamp(position_from_centre.x, -limits.x, limits.x)
			position_from_centre.y = clamp(position_from_centre.y, -limits.y, limits.y)
			
			rect_global_position = position_from_centre + holder.rect_global_position + holder.rect_size/2
		else:
			hide()

func set_texture(what: Texture):
	var new_image = TextureRect.new()
	add_child(new_image)
	new_image.set_process(true)
	new_image.texture = what
	new_image.rect_size = Vector2()
	new_image.rect_pivot_offset = new_image.rect_size / 2
	new_image.rect_position = -new_image.rect_size / 2
	base_image_scale = target_size / what.get_size()
	
	image = new_image
