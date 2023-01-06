extends KinematicBody2D


var progress: float = 0
var prev_progress: float = progress
var start_position = Vector2()
export (Vector2) var other_position = Vector2()


func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	if prev_progress != progress:
		set_progress(progress)
	
	prev_progress = progress


func toggle():
	if progress > 0.99:
		go_to(0)
	if progress < 0.01:
		go_to(1)

func go_to(where: float, duration: float = 5):
	$tween.interpolate_property(self, "progress", progress, where, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$tween.start()

func set_progress(what: float):
	position = start_position.linear_interpolate( other_position, what )
