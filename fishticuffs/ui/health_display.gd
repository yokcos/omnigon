extends Control


export (Texture) var sprite = null
export (int) var frames = 2
export (int) var full_frame = 0
export (int) var empty_frame = 1
export (Vector2) var offset = Vector2(0, 16)

var target: Being = null setget set_target


func clear_sprites():
	for i in get_children():
		i.queue_free()

func update_sprites():
	clear_sprites()
	
	if is_instance_valid(target):
		for i in range(target.max_hp):
			var new_sprite = Sprite.new()
			add_child(new_sprite)
			new_sprite.texture = sprite
			new_sprite.hframes = frames
			new_sprite.position = offset * i
			
			if i < target.hp:
				new_sprite.frame = full_frame
			else:
				new_sprite.frame = empty_frame

func set_target(what: Being):
	target = what
	
	update_sprites()
	what.connect("hp_changed", self, "_on_target_hp_changed")


func _on_target_hp_changed(hp):
	update_sprites()
