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

const settings_file = "user://settings.sav"


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
		
		for this_event in controlses[action]:
			match this_event["type"]:
				"key":
					var event = InputEventKey.new()
					event.scancode = this_event["index"]
					InputMap.action_add_event(action, event)
				"joybutton":
					var event = InputEventJoypadButton.new()
					event.button_index = this_event["index"]
					InputMap.action_add_event(action, event)


func compress_settings() -> Dictionary:
	var data = {}
	var controlses = {}
	
	data["volume_music"] = volume_music
	data["volume_sfx"] = volume_sfx
	
	for action in actions:
		var events = InputMap.get_action_list(action)
		controlses[action] = []
		for this_event in events:
			var dict = {}
			if this_event is InputEventKey:
				dict = {"type": "key", "index": this_event.scancode}
			if this_event is InputEventJoypadButton:
				dict = {"type": "joybutton", "index": this_event.button_index}
			if dict.size() > 0:
				controlses[action].append(dict)
	data["controls"] = controlses
	
	return data

func uncompress_settings(data: Dictionary):
	set_volume_music( data["volume_music"] )
	set_volume_sfx( data["volume_sfx"] )
	replace_input_actions(data["controls"])

func save_settings():
	var file = File.new()
	file.open(settings_file, File.WRITE)
	var dict = compress_settings()
	file.store_var(dict)
	file.close()

func load_settings():
	var file = File.new()
	file.open(settings_file, File.READ)
	if file.is_open():
		var setts = file.get_var()
		uncompress_settings(setts)
		file.close()
