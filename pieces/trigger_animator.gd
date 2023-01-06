extends AnimationPlayer


export (String) var target_animation


func activate():
	play(target_animation)
