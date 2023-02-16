extends Node


func play_animation(what: String):
	var father = get_parent()
	if father is AnimationPlayer:
		get_parent().play(what)
	else:
		print("Error: AnimationController's parent is not an AnimationPlayer")
		get_tree().quit()
