tool
extends StaticBody2D


export (int) var length = 2 setget set_length
export (float) var speed = 20 setget set_speed

var tile_size: float = 16

const obj_auto_sprite = preload("res://pieces/auto_sprite.tscn")

const tex_left  = preload("res://props/conveyer_clockwork_left.png")
const tex_mid   = preload("res://props/conveyer_clockwork_mid.png")
const tex_right = preload("res://props/conveyer_clockwork_right.png")


func _ready() -> void:
	if !Engine.editor_hint:
		adjust_speed()
		adjust_hitbox()
		update_sprites()


func update_sprites():
	clear_sprites()
	add_sprites()

func clear_sprites():
	for i in $sprites.get_children():
		i.queue_free()

func add_sprites():
	for i in range(length):
		var new_sprite = obj_auto_sprite.instance()
		$sprites.add_child(new_sprite)
		new_sprite.position.x = i*tile_size - (length-1)*tile_size/2
		new_sprite.hframes = 4
		new_sprite.animation_speed = speed/2
		
		if i == 0:
			new_sprite.texture = tex_left
		elif i == length-1:
			new_sprite.texture = tex_right
		else:
			new_sprite.texture = tex_mid

func adjust_hitbox():
	var height: float = $hitbox.shape.extents.y
	$hitbox.shape = RectangleShape2D.new()
	$hitbox.shape.extents.x = length * tile_size / 2
	$hitbox.shape.extents.y = height

func adjust_speed():
	constant_linear_velocity.x = speed


func set_length(what: int):
	what = max(what, 2)
	length = what
	
	adjust_hitbox()
	update_sprites()

func set_speed(what: float):
	speed = what
	
	adjust_speed()
	update_sprites()
