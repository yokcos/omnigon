extends Sprite


func _process(delta: float) -> void:
	update()

func pick_texture():
	texture = get_tree().get_nodes_in_group("texture_havers")[0].tex
