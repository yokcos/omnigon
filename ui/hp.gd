extends HBoxContainer


var age: float = 0

const tex_full = preload("res://ui/hp_full.png")
const tex_empty = preload("res://ui/hp_empty.png")
const tex_poisoned = preload("res://ui/hp_poisoned.png")


func _ready() -> void:
	update_hp()
	PlayerStats.connect("hp_changed", self, "_on_hp_changed")

func _process(delta: float) -> void:
	age += delta
	
	if PlayerStats.poisoned:
		for i in range( get_child_count() ):
			var this_sprite: TextureRect = get_child(i)
			this_sprite.rect_pivot_offset = this_sprite.rect_size / 2
			this_sprite.rect_position.y = 2 * sin(age - i)
			this_sprite.rect_rotation = 45 * sin(age*.3 + i)
	else:
		for i in range( get_child_count() ):
			var this_sprite: TextureRect = get_child(i)
			this_sprite.rect_position.y = 0
			this_sprite.rect_rotation = 0


func update_hp():
	clear_hp()
	deploy_hp()

func clear_hp():
	for i in get_children():
		if i is TextureRect:
			i.queue_free()

func deploy_hp():
	for i in max(PlayerStats.max_hp, PlayerStats.hp):
		var new_rect = TextureRect.new()
		new_rect.rect_size = Vector2()
		new_rect.size_flags_vertical = 4
		
		if i < PlayerStats.hp:
			new_rect.texture = tex_poisoned if PlayerStats.poisoned else tex_full
		else:
			new_rect.texture = tex_empty
		
		add_child(new_rect)
		new_rect.rect_pivot_offset = new_rect.rect_min_size / 2


func _on_hp_changed(what: float):
	update_hp()
