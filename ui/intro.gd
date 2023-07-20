extends Control


func _ready() -> void:
	if OS.is_debug_build():
		#print_all_scancodes()
		get_tree().change_scene_to( preload("res://ui/main_menu.tscn") )

func proceed():
	get_tree().change_scene_to( preload("res://ui/main_menu.tscn") )
	GlobalSound.play_random_sfx(GlobalSound.sfx_introduce)

func print_all_scancodes():
	var strings = [
		"abcdefghijklmnopqrstuvwxyz",
		"1234567890",
		"Space",
		"Up",
		"Down",
		"Left",
		"Right",
		"Shift",
		"Enter",
	]
	
	for this_string in strings:
		var sc = OS.find_scancode_from_string(this_string)
		if sc > 0:
			print( "%s: %s" % [OS.get_scancode_string(sc), sc] )
		else:
			var output = []
			for i in range(this_string.length()):
				var this_char = this_string.substr(i, 1)
				var this_sc = OS.find_scancode_from_string(this_char)
				var this_name = OS.get_scancode_string(this_sc)
				output.append("%s: %s" % [this_name, this_sc])
			print(output)
