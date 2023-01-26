tool
extends Area2D


export (int) var length = 1 setget set_length
var actual_length: float = 0
var decay_rate: float = 0

var spacing: float = 32
var upper_border: float = 4

const tex_top: Texture = preload("res://props/ladder_top.png")
const tex_mid: Texture = preload("res://props/ladder_mid.png")
const tex_bot: Texture = preload("res://props/ladder_bot.png")


func _init() -> void:
	add_to_group("ladders")

func _ready() -> void:
	actual_length = float(length)
	update_sprites()

func _process(delta: float) -> void:
	if !Engine.editor_hint:
		actual_length -= decay_rate * delta
		var target_length = ceil(actual_length)
		if target_length != length:
			if target_length <= 0:
				queue_free()
			else:
				set_length(target_length)


func update_sprites():
	clear_sprites()
	add_sprites()

func clear_sprites():
	for i in $sprites.get_children():
		i.queue_free()

func add_sprites():
	for i in range(length):
		var new_sprite = Sprite.new()
		$sprites.add_child(new_sprite)
		new_sprite.position.y = i*spacing
		
		if i == 0:
			new_sprite.texture = tex_top
		elif i == length-1:
			new_sprite.texture = tex_bot
		else:
			new_sprite.texture = tex_mid

func adjust_hitbox():
	var width = $hitbox.shape.extents.x
	$hitbox.shape = RectangleShape2D.new()
	$hitbox.shape.extents.x = width
	$hitbox.shape.extents.y = spacing*length/2 + upper_border
	$hitbox.position.y = spacing * (length-1) / 2 - upper_border


func add_exception(what: PhysicsBody2D):
	$top.add_collision_exception_with(what)

func remove_exception(what: PhysicsBody2D):
	$top.remove_collision_exception_with(what)


func set_length(what: int):
	length = max(what, 1)
	
	update_sprites()
	adjust_hitbox()
