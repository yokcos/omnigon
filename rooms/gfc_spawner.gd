extends Node2D


var player: Being = null
var used: bool = false

const obj_gfc = preload("res://entities/enemies/grandfathercrook.tscn")


func _ready() -> void:
	if WorldSaver.load_data("bosses_defeated") > 0:
		used = true
	elif WorldSaver.load_data("boss_summoned"):
		used = true
		call_deferred("deploy_boss")

func _process(delta: float) -> void:
	if !is_instance_valid(player):
		player = Game.get_player()


func activate():
	if !used and is_instance_valid(player):
		GlobalSound.play_random_sfx_2d(GlobalSound.sfx_tock, player.global_position)
		used = true
		player.time_freeze($timer.wait_time)
		$timer.start()
		WorldSaver.save_data("boss_summoned", true)

func deploy_boss():
	var new_gfc = obj_gfc.instance()
	Game.deploy_instance_instant(new_gfc, global_position)
	new_gfc.arrive()
	Game.set_boss(new_gfc)


func _on_timer_timeout() -> void:
	deploy_boss()
