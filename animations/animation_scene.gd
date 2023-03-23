extends Node2D


func play():
	if has_node("animator"):
		$animator.stop()
		$animator.play("play")
