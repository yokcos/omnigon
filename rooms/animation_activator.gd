extends Node


export (String) var animation = "play"


func activate():
	var father = get_parent()
	if father is AnimationPlayer:
		father.play(animation)
