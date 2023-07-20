class_name ControlsPreset
extends Resource


export (Array, InputEvent) var up
export (Array, InputEvent) var down
export (Array, InputEvent) var left
export (Array, InputEvent) var right

export (Array, InputEvent) var jump
export (Array, InputEvent) var attack
export (Array, InputEvent) var shift
export (Array, InputEvent) var interact

func get_controls() -> Dictionary:
	return {
		"move_up": up,
		"move_down": down,
		"move_left": left,
		"move_right": right,
		
		"jump": jump,
		"attack": attack,
		"shift": shift,
		"interact": interact,
	}
