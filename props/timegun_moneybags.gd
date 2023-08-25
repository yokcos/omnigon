extends "res://props/animator_haver.gd"


func focus_here():
	Game.focus_cam( $focus.global_position, .8 )
	Game.zoom_cam(.6)

func unfocus():
	Game.unfocus_cam()
	Game.zoom_cam()
