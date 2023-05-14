extends StaticBody2D


var is_open = false
var spawn_position: Vector2 = Vector2()


func _ready():
	spawn_position = global_position
	
	if WorldSaver.load_data(spawn_position):
		is_open = true
		$hitbox.disabled = true
		$sprite.frame = 7


func activate():
	if !is_open:
		is_open = true
		$hitbox.disabled = true
		$animator.play("activate")
		
		WorldSaver.save_data(spawn_position, true)


func get_shifted():
	$sprite.flip_h = !$sprite.flip_h


