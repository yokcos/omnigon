extends KinematicBody2D


var velocity: Vector2 = Vector2()
var gravy: float = 98
var colours: Array = [Color("328464"), Color("5daf8d"), Color("23674e")]
var colour: Color = colours[0]

const tex_splash = preload("res://fx/vomit_splash.png")


func _ready() -> void:
	$sprite.frame = randi() % $sprite.hframes
	
	var index = randi() % colours.size()
	colour = colours[index]

func _physics_process(delta: float) -> void:
	move_and_slide(velocity)
	velocity.y += gravy * delta
	
	if get_slide_count() > 0:
		var hit := get_slide_collision(0)
		
		var pos = hit.position
		var norm = hit.normal
		
		var new_fx = Game.deploy_fx(tex_splash, pos + norm*8)
		new_fx.rotation = norm.angle() + PI/2
		
		var tex: WorldTexture = get_texture("splashes")
		if tex:
			var angles = range(-2, 3)
			for i in range(angles.size()):
				var this_angle = angles[i] * .4 + rand_range(-.1, .1)
				splat(pos - tex.position, velocity.normalized().rotated(this_angle), tex)
		
		queue_free()


func halt():
	velocity = Vector2()
	gravy = 0

func get_texture(id: String) -> WorldTexture:
	for i in get_tree().get_nodes_in_group("texture_havers"):
		if i.texture_id == id:
			return i.tex
	return null

func splat(pos: Vector2, direction: Vector2, tex: WorldTexture):
	var splat_size: float = rand_range(5, 15)
	var i: int = 0
	while splat_size > 0:
		deploy_circle(tex, pos, int(splat_size), colour)
		
		pos += direction * splat_size * rand_range(.5, 2)
		splat_size -= rand_range(1, 4)
		i += 1

func deploy_circle(tex: ImageTexture, where: Vector2, radius: int, this_colour: Color):
	var image = tex.get_data()
	image.lock()
	
	for x in range(-radius, radius+1):
		var this_x: int = int(where.x + x)
		if this_x < 0 or this_x >= image.get_width():
			break
		for y in range(-radius, radius+1):
			var this_y: int = int(where.y + y)
			if this_y < 0 or this_y >= image.get_height():
				break
			if Vector2(x, y).length_squared() < radius*radius:
				image.set_pixel(this_x, this_y, this_colour)
	
	image.unlock()
	tex.set_data(image)
