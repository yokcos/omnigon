extends Node2D


var distances: Array = [5.0, 1.5, 1.375, 1.25, 1.125, 1.0]
var sizes: Array = [32, 2, 2, 2, 2, 2]
var motion_scales: Array = sizes.duplicate()
var room_centre: float = 2176


func _ready() -> void:
	for i in range( distances.size() ):
		motion_scales[i] = pow(2, -distances[i])
		sizes[i] *= motion_scales[i]
	
	for i in range( get_child_count() ):
		var this_layer: Sprite = get_child(i)
		this_layer.scale = Vector2(sizes[i], sizes[i])
		
		if i > 0:
			this_layer.z_index = i

func _process(delta: float) -> void:
	var cam = Game.camera
	if is_instance_valid(cam):
		var pos = cam.get_actual_position()
		var offset = pos.x - room_centre
		
		for i in get_child_count():
			var this_layer: Sprite = get_child(i)
			this_layer.position = pos
			this_layer.position.x -= offset * motion_scales[i]
