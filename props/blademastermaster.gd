extends "res://props/animator_haver.gd"


var target: Node2D = null setget set_target


func set_target(what: Node2D):
	target = what

func smack_target():
	print("BMM: performing smack")
	var animdur = .2
	
	$tween.interpolate_property(
		self, "global_position",
		global_position, target.global_position, animdur,
		Tween.TRANS_CUBIC, Tween.EASE_IN
	)
	$tween.interpolate_property(
		self, "global_position",
		target.global_position, global_position, animdur,
		Tween.TRANS_CUBIC, Tween.EASE_OUT, animdur
	)
	$tween.start()
