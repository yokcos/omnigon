extends Node


var volume_music: float = 0.7 setget set_volume_music
var volume_sfx: float = 0.7 setget set_volume_sfx
var fullscreen: bool = false setget set_fullscreen
var curses = []

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
var duplicate_actions: Dictionary = {
	"move_up":    ["ui_up"],
	"move_down":  ["ui_down"],
	"move_left":  ["ui_left"],
	"move_right": ["ui_right"],
	"jump":       ["ui_accept"],
}
var default_actions: Dictionary = {
	"ui_accept": ["Space", "Enter"]
}

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

func apply_duplicate_actions():
	for this_action in duplicate_actions:
		for this_target in duplicate_actions[this_action]:
			InputMap.action_erase_events(this_target)
			for this_event in InputMap.get_action_list(this_action):
				InputMap.action_add_event(this_target, this_event)

func add_default_actions():
	for this_action in default_actions:
		for this_code in default_actions[this_action]:
			if this_code is String:
				var new_event = InputEventKey.new()
				var sc = OS.find_scancode_from_string(this_code)
				new_event.pressed = true
				new_event.scancode = sc
				InputMap.action_add_event(this_action, new_event)
			else:
				var new_event = InputEventJoypadButton.new()
				new_event.pressed = true
				new_event.button_index = this_code
				InputMap.action_add_event(this_action, new_event)


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
	data["curses"] = curses
	data["fullscreen"] = fullscreen
	
	return data

func uncompress_settings(data: Dictionary):
	set_volume_music( data["volume_music"] )
	set_volume_sfx( data["volume_sfx"] )
	replace_input_actions( data["controls"] )
	if data.has("curses"): curses = data["curses"]
	if data.has("fullscreen"): set_fullscreen(data["fullscreen"])

func save_settings():
	apply_duplicate_actions()
	add_default_actions()
	
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
	
	Game.remove_cursed_files()
	apply_duplicate_actions()
	add_default_actions()

func set_fullscreen(what: bool):
	OS.window_fullscreen = what
	fullscreen = what
