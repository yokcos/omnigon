extends Area2D


var vertices: int = 10
var mode: int = 0
var spawn_position: Vector2 = Vector2()

const obj_vertex = preload("res://entities/vertex.tscn")


func _ready() -> void:
	add_to_group("saveables")
	spawn_position = global_position
	
	var these_vertices = WorldSaver.load_data(spawn_position)
	if these_vertices != null:
		vertices -= these_vertices


func get_saved():
	return {
		"mode": mode
	}

func get_loaded(what: Dictionary):
	if what.has("mode"):
		mode = what["mode"]
	
	update_sprites()

func update_sprites():
	$sprites/sprite0.visible = mode == 0
	$sprites/sprite1.visible = mode == 1

func get_shifted():
	if !$animator.is_playing():
		mode = 1 - mode
		
		update_sprites()

func get_punched():
	if mode == 1:
		for i in range(vertices):
			var new_vertex = obj_vertex.instance()
			var base_impulse: Vector2 = Vector2(0, rand_range(-800, -200)).rotated(rand_range(-.2, .2))
			new_vertex.apply_central_impulse( base_impulse.rotated(global_rotation) )
			new_vertex.source = self
			
			Game.deploy_instance(new_vertex, global_position + Vector2(0, -16).rotated(global_rotation))
		if vertices > 0:
			vertices = 0
			$sfx_money.play()
	else:
		$animator.play("explode")


