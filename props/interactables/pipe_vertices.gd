extends "res://props/interactables/pipe.gd"


export (int) var vertices = 10

const obj_vertex = preload("res://entities/vertex.tscn")


func _ready() -> void:
	var these_vertices = WorldSaver.load_data(spawn_position)
	if these_vertices != null:
		vertices -= these_vertices
		
		if vertices <= 0:
			$body/sprite.frame = 1
			$body/sprite_not.frame = 1
			active = false


func open_pipe():
	var result = .open_pipe()
	
	if result:
		for i in range(vertices):
			var new_vertex = obj_vertex.instance()
			var base_impulse: Vector2 = Vector2(0, rand_range(-800, -200)).rotated(rand_range(-.2, .2))
			new_vertex.apply_central_impulse( base_impulse.rotated(global_rotation) )
			new_vertex.source = self
			
			Game.deploy_instance(new_vertex, global_position + Vector2(0, -16).rotated(global_rotation))



