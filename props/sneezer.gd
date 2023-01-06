extends Node2D


const obj_snot = preload("res://projectiles/snot.tscn")


func activate():
	$animator.play("achoo")

func sneeze():
	var new_snot = obj_snot.instance()
	Game.deploy_instance(new_snot, $barrel.global_position)
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_sneeze, global_position)
	new_sfx.max_distance = 500
