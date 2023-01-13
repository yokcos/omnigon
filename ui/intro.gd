extends Control


func _ready() -> void:
	if OS.is_debug_build():
		get_tree().change_scene_to( preload("res://ui/main_menu.tscn") )

func proceed():
	get_tree().change_scene_to( preload("res://ui/main_menu.tscn") )
	GlobalSound.play_random_sfx(GlobalSound.sfx_introduce)
