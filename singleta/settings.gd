extends Node


var volume_music: float = 0.7 setget set_volume_music
var volume_sfx: float = 0.7 setget set_volume_sfx

const actions = [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
	"jump",
	"attack",
	"interact",
	"shift",
]


signal volume_music_changed
signal volume_sfx_changed


func set_volume_music(what: float):
	volume_music = what
	emit_signal("volume_music_changed")

func set_volume_sfx(what: float):
	volume_sfx = what
	emit_signal("volume_sfx_changed")

func replace_input_actions(controlses: Dictionary):
	for action in actions:
		var inputs = InputMap.get_action_list(action)
		for i in range(0, inputs.size()):
			InputMap.action_erase_event(action, inputs[i])
		
		for event in controlses[action]:
			InputMap.action_add_event(action, event)


func compress_settings() -> Dictionary:
	var data = {}
	var controlses = {}
	
	data["volume_music"] = volume_music
	data["volume_sfx"] = volume_sfx
	
	for action in actions:
		controlses[action] = InputMap.get_action_list(action)
	data["controls"] = controlses
	
	return data

func uncompress_settings(data: Dictionary):
	set_volume_music( data["volume_music"] )
	set_volume_sfx( data["volume_sfx"] )
	replace_input_actions(data["controls"])
