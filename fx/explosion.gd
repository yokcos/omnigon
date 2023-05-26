extends "res://pieces/hurtbox.gd"


func _ready() -> void:
	$sprite.rotation = randf() * PI*2
	Game.shake_cam_random(4)
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_blast, global_position )
