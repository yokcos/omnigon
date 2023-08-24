extends Node2D


func play_animation(what: String):
	$animator.play(what)

func stop_animation():
	$animator.stop()
