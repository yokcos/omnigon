extends "res://ui/artwork/artwork.gd"


var current_option: int = 0
var animdur: float = .2
onready var options: Node = $options


func _ready() -> void:
	show_option(current_option)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		apply_option(current_option - 1)
	
	if event.is_action_pressed("move_right"):
		apply_option(current_option + 1)


func apply_option(what: int):
	var prev_option: int = current_option
	current_option = posmod(what, options.get_child_count())
	show_option(current_option, prev_option)

func get_option_object(what: int) -> Control:
	return options.get_child(what) as Control

func show_option(new_option: int, prev_option: int = -1):
	if prev_option < 0:
		for i in options.get_children():
			i.hide()
		options.get_child(new_option).show()
	else:
		var new_option_object: Control = get_option_object(new_option)
		var prev_option_object: Control = get_option_object(prev_option)
		
		new_option_object.show()
		prev_option_object.show()
		
		$tween.interpolate_property(
			new_option_object, "modulate",
			Color(1, 1, 1, 0), Color(1, 1, 1, 1),
			animdur, Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		$tween.interpolate_property(
			prev_option_object, "modulate",
			Color(1, 1, 1, 1), Color(1, 1, 1, 0),
			animdur, Tween.TRANS_CUBIC, Tween.EASE_IN
		)
		
		$tween.interpolate_property(
			new_option_object, "rect_rotation",
			20, 0,
			animdur, Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		$tween.interpolate_property(
			prev_option_object, "rect_rotation",
			0, -20,
			animdur, Tween.TRANS_CUBIC, Tween.EASE_IN
		)
		
		$tween.start()
