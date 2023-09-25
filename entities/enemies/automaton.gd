extends Enemy


var obj_turret = load("res://entities/enemies/turret.tscn")
var obj_bullet = preload("res://projectiles/bullet.tscn")


func get_shifted():
	Game.replace_instance(self, obj_turret.instance())

func shoot():
	for i in range(4):
		var new_bullet = obj_bullet.instance()
		Game.deploy_instance(new_bullet, $flippable/barrel.global_position)
		#new_bullet.velocity = Vector2(40 + i*20, 0) * flip_node.scale
		new_bullet.acceleration = Vector2(40 + i*20, 0) * flip_node.scale
	
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_DT, global_position)


func _on_attacc_activated() -> void:
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_whoosh, global_position)
	new_sfx.relative_volume = 0.6
	new_sfx.randomise_pitch(0.8, 1.2)

func _on_entity_detector_activated() -> void:
	$fsm/patrol.perform_action("attacc")

func _on_recover_entered() -> void:
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_automaton_recharge, global_position)
