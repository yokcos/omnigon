extends Node2D


var motion_scales: Array = [0, 0.02, 0.04, 0.06, 0.08, 0.10]
var sizes: Array = [1, 0.6, 0.7, 0.8, 0.9, 1]
var room_centre: float = 2176


func _ready() -> void:
	for i in get_child_count():
		var this_layer: Sprite = get_child(i)
		this_layer.scale = Vector2(sizes[i], sizes[i])

func _process(delta: float) -> void:
	var cam = Game.camera
	if is_instance_valid(cam):
		var pos = cam.get_actual_position()
		var offset = pos.x - room_centre
		
		for i in get_child_count():
			var this_layer: Sprite = get_child(i)
			this_layer.position = pos
			this_layer.position.x -= offset * motion_scales[i]
