extends Sprite


export (float) var animation_speed = 10
var has_set_actual_frame: bool = false
var actual_frame: float = 0 setget set_actual_frame


func _ready() -> void:
	if !has_set_actual_frame:
		actual_frame = frame

func _process(delta: float) -> void:
	actual_frame += animation_speed * delta
	actual_frame = fposmod(actual_frame, hframes*vframes)
	frame = int(actual_frame)


func set_actual_frame(what: float):
	actual_frame = what
	has_set_actual_frame = true
