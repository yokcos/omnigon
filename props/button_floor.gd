extends Node2D


var obj_button_laser = load("res://props/button_laser.tscn")

signal activated


func _process(delta: float) -> void:
	var has_thing = $detector.get_overlapping_bodies().size() > 0
	if has_thing and $sprite.frame == 0:
		GlobalSound.play_random_sfx_2d( GlobalSound.sfx_click, global_position )
		emit_signal("activated")
	$sprite.frame = 1 if has_thing else 0


func _on_shift() -> void:
	var new_button = obj_button_laser.instance()
	for i in get_signal_connection_list( "activated" ):
		new_button.connect("activated", i["target"], i["method"])
	Game.replace_instance(self, new_button)
