extends Label


func _process(delta: float) -> void:
	if percent_visible < 1:
		percent_visible += delta * 5
