extends TextInteractable


export (int) var shift_frame = 2

const default_frame: int = 1
const frames: int = 4


func _ready() -> void:
	$sprite.hframes = frames
	$sprite.frame = default_frame


func _on_shift():
	if $sprite.frame == default_frame:
		$sprite.frame = shift_frame
	else:
		$sprite.frame = default_frame
