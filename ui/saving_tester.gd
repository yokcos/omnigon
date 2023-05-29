extends Node


func activate():
	var events
	var dict
	
	events = InputMap.get_action_list("move_right")
	for this_event in events:
		if this_event is InputEventKey:
			var codes = [this_event.scancode, this_event.physical_scancode]
			print("Event has scancode %s and physical scancode %s" % codes)
	
	Settings.save_settings()
	Settings.load_settings()
	
	events = InputMap.get_action_list("move_right")
	for this_event in events:
		if this_event is InputEventKey:
			var codes = [this_event.scancode, this_event.physical_scancode]
			print("Event has scancode %s and physical scancode %s" % codes)
	
	var dir = Directory.new()
	dir.remove("user://settings.sav")

