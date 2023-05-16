extends Node2D

var shaft = preload("res://fishticuffs/decor/shaft.tscn")
export var length = 320

func _process(delta):
	if randf()*120 < 1.0:
		var new_shaft = shaft.instance()
		new_shaft.position.x = randf() * 640 - 320
		new_shaft.length = length
		
		#var scale_degree = level.depth / 2400
		#var max_y = pow(scale_degree, 0.5)
		
		var depth = randf()
		var size = 0.75 - depth*0.5
		#new_shaft.position.y = depth*max_y
		new_shaft.depth = depth
		new_shaft.width = rand_range(5, 40 - 20*depth)
		new_shaft.duration = rand_range(2, 9)
		new_shaft.z_index = -depth
		
		var darkness = randf() * 1.2
		if darkness > 1:
			new_shaft.get_node("visual").color = Color("2789cd")
		if darkness > 2.5:
			new_shaft.get_node("visual").color = Color("1b2447")
		
		add_child(new_shaft)
