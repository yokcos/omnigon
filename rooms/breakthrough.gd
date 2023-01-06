extends "res://rooms/room.gd"


func explode():
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_blast_large, $explosion.global_position)


func _on_tile_detector_updated(active: bool) -> void:
	$anything_detector.active = !active
