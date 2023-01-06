extends HBoxContainer


const tex_full = preload("res://ui/hp_full.png")
const tex_empty = preload("res://ui/hp_empty.png")


func _ready() -> void:
	update_hp()
	PlayerStats.connect("hp_changed", self, "_on_hp_changed")


func update_hp():
	clear_hp()
	deploy_hp()

func clear_hp():
	for i in get_children():
		if i is TextureRect:
			i.queue_free()

func deploy_hp():
	for i in PlayerStats.max_hp:
		var new_rect = TextureRect.new()
		new_rect.rect_size = Vector2()
		new_rect.size_flags_vertical = 4
		
		if i < PlayerStats.hp:
			new_rect.texture = tex_full
		else:
			new_rect.texture = tex_empty
		
		add_child(new_rect)


func _on_hp_changed(what: float):
	update_hp()
