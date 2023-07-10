extends Node


var default_controls: Dictionary = {
	"jump":     [KEY_Z, KEY_X],
	"attack":   [KEY_C, KEY_V],
	"shift":    [KEY_A, KEY_S],
	"interact": [KEY_D, KEY_F],
}
var old_save_file = "user://world.sav"
var save_file = "user://omnigon%s.sav"
var save_slot: int = -1
var keyboard_layouts = {
	"QWERTY": {
		"Z": "Z", "X": "X",
		"C": "C", "V": "V",
		"A": "A", "S": "S",
		"D": "D", "F": "F",
	},
	"AZERTY": {
		"Z": "W", "X": "X",
		"C": "C", "V": "V",
		"A": "Q", "S": "S",
		"D": "D", "F": "F",
	},
	"QZERTY": {
		"Z": "W", "X": "X",
		"C": "C", "V": "V",
		"A": "A", "S": "S",
		"D": "D", "F": "F",
	},
	"DVORAK": {
		"Z": ";", "X": "Q",
		"C": "J", "V": "K",
		"A": "A", "S": "O",
		"D": "E", "F": "U",
	},
	"NEO": {
		"Z": "Ü", "X": "Ö",
		"C": "Ä", "V": "P",
		"A": "U", "S": "I",
		"D": "A", "F": "E",
	},
	"COLEMAK": {
		"Z": "Z", "X": "X",
		"C": "C", "V": "V",
		"A": "A", "S": "R",
		"D": "S", "F": "T",
	},
	"ERROR": {
		"Z": "Z", "X": "X",
		"C": "C", "V": "V",
		"A": "A", "S": "S",
		"D": "D", "F": "F",
	},
}

var gameholder: Node2D = null
var world: Node2D = null
var camera: Camera2D = null
var background_colour: Color = Color("e3e6ff")
var current_popup: Control = null
var controllering: bool = false

var closest_tooltipable: Node2D = null
var current_boss: Being = null setget set_boss

var in_game: bool = false


const obj_fx = preload("res://fx/fx_transient.tscn")

var obj_mattress: PackedScene = load("res://props/mattress.tscn")
var obj_mattress_gremlin: PackedScene = load("res://props/mattress_gremlin.tscn")
var screen_scale = 2
var rsoo_loaded: bool = false


signal world_changed
signal boss_changed
signal popup_arisen


func _ready() -> void:
	AudioServer.set_bus_layout(load("res://bussingsworth.tres"))
	var base_width: int = ProjectSettings.get_setting("display/window/size/width")
	var base_height: int = ProjectSettings.get_setting("display/window/size/height")
	var base_size: Vector2 = Vector2( base_width, base_height )
	
	OS.window_size = base_size*screen_scale
	OS.window_position = OS.get_screen_size()/2 - OS.window_size/2
	
	#call_deferred("load_game")
	Settings.call_deferred("load_settings")
	
	rename_old_save_file()
	apply_default_controls()

func _process(delta: float) -> void:
	closest_tooltipable = get_closest_tooltipable()
	
	if current_boss:
		if !is_instance_valid(current_boss):
			set_boss(null)
			
			GlobalSound.resume_music()


func load_rsoo():
	if !rsoo_loaded:
		ProjectSettings.load_resource_pack("res://RSOO.pck")
		
		rsoo_loaded = true

func unload_rsoo():
	if rsoo_loaded:
		delete_folder("res://rsoo/")
		
		rsoo_loaded = false

func delete_folder(path, dir: Directory = null):
	if !dir: dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		var full_path = path + fname
		
		if dir.current_is_dir():
			delete_folder(full_path, dir)
		else:
			dir.remove(full_path)
		
		fname = dir.get_next()
	
	dir.remove(path)

func apply_default_controls():
	var file = File.new()
	var layout = OS.get_latin_keyboard_variant()
	
	if !file.file_exists(save_file):
		for action in default_controls:
			for key in default_controls[action]:
				var new_event = InputEventKey.new()
				var txt = OS.get_scancode_string(key)
				
				new_event.physical_scancode = key
				var this_layout = keyboard_layouts[layout]
				if this_layout.has(txt):
					new_event.scancode = OS.find_scancode_from_string( keyboard_layouts[layout][txt] )
				else:
					new_event.scancode = OS.find_scancode_from_string( txt )
				InputMap.action_add_event(action, new_event)

func set_world(what: Node2D):
	world = what

func get_player() -> KinematicBody2D:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		return players[0]
	else:
		return null

func get_ui() -> Control:
	if is_instance_valid(gameholder):
		return gameholder.get_node("ui/ui") as Control
	return null

func get_closest_tooltipable() -> Node2D:
	var player = get_player()
	if player:
		var player_position = player.global_position
		
		var closest_distance = 1000000
		var closest_interactable = null
		
		for interactable in get_tree().get_nodes_in_group("tooltipables"):
			if interactable.active:
				var dist = interactable.global_position.distance_squared_to(player_position)
				if dist < closest_distance and dist <= interactable.highlight_distance * interactable.highlight_distance:
					if interactable.thru_walls or interactable.check_line_of_sight(player_position):
						closest_distance = dist
						closest_interactable = interactable
		
		return closest_interactable
	else:
		return null

func shake_cam_random(amount: float):
	shake_cam(amount, randf() * 2*PI)

func shake_cam(amount: float, direction: float):
	if camera:
		camera.offset += Vector2(amount, 0).rotated(direction)

func is_instance_in_mattress(what: Node2D, activate: bool = true) -> bool:
	var result: bool = false
	
	for i in get_tree().get_nodes_in_group("mattresses"):
		var checks: Array = i.overlappers
		if checks.has(what):
			result = true
			i.activate()
	
	return result

func summon_mattress_gremlin(where: Vector2):
	if PlayerStats.has_hat("gremlin_hive"):
		for i in get_tree().get_nodes_in_group("mattresses"):
			if i.has_point(where + Vector2(0, -8)):
				return false
		
		var gremlin_offset: Vector2 = Vector2(16, 0)
		if randf()*2 < 1:
			gremlin_offset.x *= -1
		
		var new_mattress = obj_mattress.instance()
		deploy_instance(new_mattress, where)
		
		var new_gremlin = obj_mattress_gremlin.instance()
		deploy_instance(new_gremlin, where + gremlin_offset)
		
		return true
	return false

func get_input_string(action: String):
	var actions = InputMap.get_action_list(action)
	for this_action in actions:
		if this_action is InputEventKey:
			return OS.get_scancode_string(this_action.scancode)
	return "??"

func replace_input_string(text: String):
	var full_text = text
	var opening = text.find("{")
	while opening >= 0:
		var after = text.right(opening+1)
		var closing = after.find("}")
		if closing >= 0:
			var contents = after.left(closing)
			
			if InputMap.get_actions().has(contents):
				var replaceur = text.substr(opening, closing+2)
				full_text = full_text.replace(replaceur, get_input_string(contents))
		
		text = after
		opening = text.find("{")
	
	return full_text

# -------- -------- -------- -------- SAVING AND LOADING -------- -------- -------- --------

func rename_old_save_file():
	var dir = Directory.new()
	if dir.file_exists(old_save_file):
		var i = 0
		while true:
			if !save_file_exists(i):
				dir.rename(old_save_file, get_save_file_name(i))
				break
			i += 1

func remove_cursed_files(start: int = 0):
	var i: int = start
	while true:
		if save_file_exists(i):
			var this_file = load_game(i)
			if this_file["player"].has("id"):
				if Settings.curses.has(this_file["player"]["id"]):
					remove_save_file(i)
					remove_cursed_files(i)
		else:
			break
		
		i += 1

func get_save_file_name(slot: int = save_slot):
	return save_file % str(slot).pad_zeros(4)

func save_file_exists(slot: int) -> bool:
	var file_name = get_save_file_name(slot)
	var dir = Directory.new()
	return dir.file_exists(file_name)

func save_game():
	if save_slot < 0:
		return false
	
	PlayerStats.update_position()
	var file = File.new()
	file.open(get_save_file_name(), File.WRITE)
	var data = {
		"world": WorldSaver.data,
		"player": PlayerStats.compress_data(),
		#"settings": Settings.compress_settings()
	}
	var file_start = file.get_position()
	file.store_var(data, true)
	file.seek(file_start)
	file.close()

func load_game(slot: int = save_slot) -> Dictionary:
	var file = File.new()
	file.open(get_save_file_name(slot), File.READ)
	if file.is_open():
		var file_start = file.get_position()
		var data = file.get_var(true)
		file.seek(file_start)
		
		file.close()
		return data
	return {}

func apply_save_file(data: Dictionary):
	#var settings = data["settings"]
	var world_data = data["world"]
	var player_stats = data["player"]
	
	#Settings.uncompress_settings(settings)
	WorldSaver.data = world_data
	PlayerStats.uncompress_data(player_stats)

func remove_save_file(slot: int = save_slot):
	var i: int = 0
	var file_count: int = 0
	var dir := Directory.new()
	
	while true:
		if !save_file_exists(i):
			break
		i += 1
	
	file_count = i
	
	dir.remove( get_save_file_name(slot) )
	for j in range(slot, file_count-1):
		dir.rename( get_save_file_name(j+1), get_save_file_name(j) )

# -------- -------- -------- -------- -------- -------- -------- --------

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false

func achieve_achievement(what: String):
	pass

func get_all_descendents(what: Node):
	var output: Array = [what]
	
	for i in what.get_children():
		output.append_array( get_all_descendents(i) )
	
	return output


func set_boss(what: Being):
	current_boss = what
	emit_signal("boss_changed", what)
	
	if what and what.boss_theme != "":
		GlobalSound.play_temp_music(what.boss_theme)
	else:
		GlobalSound.reset_music()

func summon_popup(title: String, text: String, egress: String = "Alrighty", anchor: Node2D = null):
	if gameholder and !is_instance_valid(current_popup):
		gameholder.add_popup(title, text, egress, anchor)

func summon_popup_world(this_world: PackedScene, title = "Witness"):
	if gameholder and !is_instance_valid(current_popup):
		current_popup = gameholder.deploy_popup_world(this_world)
		current_popup.set_title(title)
		current_popup.connect("tree_exiting", self, "_on_popup_slain")
		return current_popup
	else:
		return null

func summon_popup_secret(what: Secret):
	if gameholder and !current_popup:
		current_popup = gameholder.deploy_popup_secret(what)
		current_popup.connect("tree_exiting", self, "_on_popup_slain")
		return current_popup
	else:
		return null

func popup_exists() -> bool:
	return gameholder and gameholder.count_popups() > 0

func exit_game():
	world = null
	gameholder = null
	in_game = false
	save_slot = -1
	get_tree().change_scene("res://ui/main_menu.tscn")

func switch_room(which: PackedScene):
	if is_instance_valid(gameholder):
		if is_instance_valid(world):
			world.queue_free()
			world = null
		
		var new_world = which.instance()
		world = new_world
		gameholder.call_deferred("add_world", new_world)
		
		emit_signal("world_changed", world)

func replace_instance(old_thing: Node2D, new_thing: Node2D):
	var thing_position = old_thing.global_position
	var thing_rotation = old_thing.global_rotation
	var thing_index = old_thing.get_position_in_parent()
	var father = old_thing.get_parent()
	
	old_thing.queue_free()
	
	father.add_child(new_thing)
	father.move_child(new_thing, thing_index)
	new_thing.global_position = thing_position
	new_thing.global_rotation = thing_rotation

func deploy_fx(sprite: Texture, where: Vector2, frames: int = 8):
	var new_fx = obj_fx.instance()
	new_fx.texture = sprite
	new_fx.hframes = frames
	deploy_instance(new_fx, where)
	return new_fx

func deploy_instance(what: Node2D, where: Vector2):
	if world and is_instance_valid(world):
		world.call_deferred("deploy_instance", what, where)
	else:
		what.queue_free()
		print("Game error: Attempting to deploy an instance with no world")

func deploy_instance_instant(what: Node2D, where: Vector2):
	if world and is_instance_valid(world):
		world.deploy_instance(what, where)
	else:
		what.queue_free()
		print("Game error: Attempting to instantly deploy an instance with no world")

func deploy_ui_instance(what: Control, where: Vector2):
	var ui = get_ui()
	if is_instance_valid(ui):
		ui.add_child(what)
		what.rect_position = where


func _on_popup_slain():
	current_popup = null
