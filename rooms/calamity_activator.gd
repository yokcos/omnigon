extends Node2D


export (NodePath) var parallaxor = ""

var obj_calamity = preload("res://entities/calamity.tscn")
var current_calamity: Node2D = null

var armed: bool = false
var used: bool = false


func activate():
	if armed and !is_instance_valid(current_calamity):
		var new_calamity = obj_calamity.instance()
		current_calamity = new_calamity
		add_child(new_calamity)
		
		if has_node(parallaxor):
			var distances = get_node(parallaxor).distances
			new_calamity.distances = distances
		
		armed = false

func deactivate():
	if is_instance_valid(current_calamity):
		current_calamity.retreat()
		current_calamity = null
		
		GlobalSound.play_temp_music("433")
	
	armed = true
