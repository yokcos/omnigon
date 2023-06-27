extends StaticBody2D


export (String, MULTILINE) var error_message = ""
export (int) var lighter_type = 0

var burning: bool = false
var spawn_position: Vector2 = Vector2()

const obj_particulation = preload("res://fx/part_flame_barricade.tscn")
const obj_woodflakes = preload("res://fx/part_woodflakes.tscn")


func _ready() -> void:
	spawn_position = global_position
	if WorldSaver.load_data(spawn_position):
		queue_free()

func ignite():
	var new_particulation = obj_particulation.instance()
	new_particulation.connect("stopped", self, "_on_particulation_stopped")
	Game.deploy_instance(new_particulation, global_position)
	WorldSaver.save_data(spawn_position, true)
	burning = true
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_gate_burn, global_position)

func die():
	for i in [-1, 0, 1]:
		var new_woodflakes = obj_woodflakes.instance()
		Game.deploy_instance(new_woodflakes, global_position + Vector2(0, 48*i))
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_gate_destruction, global_position)
	queue_free()


func _on_interactable_activated() -> void:
	var result = PlayerStats.consume_lighter(lighter_type)
	
	if result:
		ignite()
	else:
		Game.summon_popup("Error", error_message, "Ah piss", self)

func _on_particulation_stopped():
	die()
