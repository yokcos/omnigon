extends "res://props/interactables/pipe.gd"


export (int) var type = 0

const lighters = [
	preload("res://entities/lighter_basic.tscn"),
	preload("res://entities/lighter_sophisticated.tscn"),
]


func _ready() -> void:
	if WorldSaver.load_data(spawn_position):
		$body/sprite.frame = 1
		$body/sprite_not.frame = 1
		active = false
	
	description = "Pipe"
	verb = "Unseal"


func open():
	var result = .open()
	
	if result:
		var new_lighter = lighters[type].instance()
		var base_impulse: Vector2 = Vector2(0, rand_range(-800, -200)).rotated(rand_range(-.2, .2))
		new_lighter.apply_central_impulse( base_impulse.rotated(global_rotation) )
		new_lighter.source_position = spawn_position
		
		Game.deploy_instance(new_lighter, global_position + Vector2(0, -16).rotated(global_rotation))


