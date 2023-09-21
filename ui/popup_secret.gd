extends "res://ui/popup_parent.gd"


var secret: Secret = null setget set_secret
var scroll_interval = 32


func _ready() -> void:
	$scroller/all.margin_left = 8
	$scroller/all.margin_right = -8

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
		$scroller.scroll_vertical += scroll_interval
	if event.is_action_pressed("move_up"):
		$scroller.scroll_vertical -= scroll_interval


func egress():
	$animator.play("depart")


func set_secret(what: Secret):
	secret = what
	
	$scroller/all/title.text = what.name
	$scroller/all/image.texture = what.image
	$scroller/all/description.text = what.description
	$scroller/all/reaction.text = what.comments
