extends Node


var data: Dictionary = {}


func save_room_data(key, value, room: Vector2):
	if !data.has(room):
		data[room] = {}
	data[room][key] = value

func save_data(key, value):
	save_room_data(key, value, Rooms.current_room)

func save_global_data(key, value):
	if !data.has("global"):
		data["global"] = {}
	data["global"][key] = value

func add_data(key, value):
	if !data.has(Rooms.current_room):
		data[Rooms.current_room] = {}
	
	if data[Rooms.current_room].has(key):
		data[Rooms.current_room][key] += value
	else:
		data[Rooms.current_room][key] = value

func load_data(key):
	return load_data_at(Rooms.current_room, key)

func load_global_data(key):
	if data.has("global"):
		if data["global"].has(key):
			return data["global"][key]
	return null

func load_data_at(where: Vector2, key):
	if data.has(where):
		if data[where].has(key):
			return data[where][key]
	
	return 0

func save_entity(what: Entity):
	pass

func cull_beings():
	for being in get_tree().get_nodes_in_group("beings"):
		if being.saving_enabled:
			being.queue_free()

func save_room():
	save_all_beings()
	save_misc()
	save_savers()

func save_all_beings():
	var all_beings = []
	
	var beings = get_tree().get_nodes_in_group("beings")
	for being in beings:
		if being.saving_enabled:
			var this_being: Dictionary = save_being(being)
			all_beings.append(this_being)
	
	save_data("beings", all_beings)

func save_being(what: Being) -> Dictionary:
	var key = what.spawn_position
	var hp = what.hp
	var pos = what.global_position
	
	var dict = {
		"hp": hp,
		"position": pos,
		"filename": what.filename,
	}
	
	if what.has_node("fsm"):
		var fsm: StateMachine = what.get_node("fsm")
		dict["state"] = fsm.state_name
	
	for i in what.extra_data.keys():
		dict[i] = what.extra_data[i]
	
	#save_data(key, dict)
	
	return dict

func save_misc():
	var all_misc: Array = []
	
	for thing in get_tree().get_nodes_in_group("saveables"):
		var dict = thing.get_saved()
		dict["pos"] = thing.global_position
		dict["filename"] = thing.filename
		all_misc.append(dict)
	
	save_data("misc", all_misc)

func unsave_beings():
	for room in data:
		var this_data = data[room]
		if this_data.has("beings"):
			this_data.erase("beings")

func load_all_beings():
	if data.has(Rooms.current_room):
		var this_room = data[Rooms.current_room]
		if this_room.has("beings"):
			var these_enities = this_room["beings"]
			
			cull_beings()
			
			for i in these_enities:
				load_being(i)

func load_being(what: Dictionary):
	if what["hp"] > 0:
		var type = what["filename"]
		var new_being: Being = load(type).instance()
		
		if !(new_being is Being):
			print("WorldSaver error! Loaded being is not in fact a Being!")
			get_tree().quit()
		
		Game.deploy_instance_instant(new_being, what["position"])
		new_being.hp = what["hp"]
		if new_being.has_node("fsm") and what.has("state"):
			new_being.get_node("fsm").set_state_string(what["state"])

func load_misc():
	if data.has(Rooms.current_room):
		var this_room = data[Rooms.current_room]
		if this_room.has("misc"):
			var these_things = this_room["misc"]
			
			for i in get_tree().get_nodes_in_group("saveables"):
				i.queue_free()
			
			for what in these_things:
				var type = what["filename"]
				var new_thing = load(type).instance()
				
				Game.deploy_instance_instant(new_thing, what["pos"])
				
				new_thing.get_loaded(what)

func save_savers():
	var savers: Array = get_tree().get_nodes_in_group("savers")
	
	if savers.size() > 0:
		var this_data = {}
		
		for i in savers:
			match i.type:
				"vertices":
					this_data["vertices"] = ( i.count() )
				
				"vertices_collected":
					this_data["vertices_collected"] = ( i.count )
		
		save_data("savers", this_data)
