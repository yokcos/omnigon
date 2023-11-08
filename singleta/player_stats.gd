extends Node

enum {
	EYES_NONE,
	EYES_BASIC,
	EYES_SHAPESHIFTER,
}

enum {
	LIGHTER_PLAIN,
	LIGHTER_SOPHISTICATED,
	LIGHTER_FANCIFUL,
	LIGHTER_IMAGINARY,
}

var save_id: int = 0
var base_max_hp: float = 3
var max_hp: float = base_max_hp
var hp: float = base_max_hp setget set_hp
var vertices: int = 0 setget set_vertices
var vertices_gained: int = 0
var position: Vector2 = Vector2()
var velocity: Vector2 = Vector2()
var eyes: int = EYES_BASIC setget set_eyes
var check_pos: Vector2 = Vector2()
var extra_data: Array = []
var lighters: Array = [0, 0, 0, 0]
var used_lighters: Array = [0, 0, 0, 0]
var main_music: String = "ingress"
var time: float = 0
var flipped: bool = false
var poisoned: bool = false
var punches: int = 0
var deaths: int = 0
var damage_taken: float = 0
var sucker: bool = false

var upgrades: Dictionary = {
	"blademaster_recover": false,
	"rapiers": false,
	"arrow_ladder": false,
	"fake_id": false,
}

var all_hats: Dictionary = {}
var available_hats: Array = [
	preload("res://hats/0001_vitality.tres"),
]
var hats: Array = []
var kills: Dictionary = {}
var enemy_deaths: Dictionary = {}
var secrets: Array = []
var cheeves: Array = []
var hatswapping: int = 0


signal eyes_changed
signal hp_changed
signal vertices_changed
signal vertices_collected
signal hats_changed
signal lighters_changed
signal secrets_changed
signal hat_too_large


func _ready() -> void:
	randomize()
	save_id = randi()
	
	load_all_hats()
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta: float) -> void:
	if Game.in_game:
		time += delta
	
	if fmod(time, .25) < delta:
		if hatswapping == 1:
			for i in hats:
				doff_hat(i)
			var these_hats = all_hats.values()
			these_hats.shuffle()
			don_hat(these_hats[0])
		if hatswapping == 2:
			for i in hats:
				doff_hat(i)
			
			var these_hats = all_hats.values()
			var hat_count = randi() % these_hats.size()
			these_hats.shuffle()
			for i in range(hat_count):
				don_hat(these_hats.pop_front())

func _input(event: InputEvent) -> void:
	if false and event.is_action_pressed("test"):
		hatswapping += 1


func load_all_hats():
	var dir := Directory.new()
	var path = "res://hats/"
	dir.open(path)
	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname != "":
		if fname.ends_with(".tres"):
			var full_path = path + fname
			var thing = load(full_path)
			if thing is Hat:
				all_hats[thing.id] = thing
		
		fname = dir.get_next()

func get_hat(id: String):
	if all_hats.has(id):
		return all_hats[id]
	else:
		return null

func set_eyes(what: int):
	eyes = what
	emit_signal("eyes_changed", what)

func set_hp(what: float):
	hp = what
	emit_signal("hp_changed", what)

func set_vertices(what: int):
	vertices = what
	emit_signal("vertices_changed", what)

func fill_hp():
	max_hp = base_max_hp
	
	# Apply hat Vitality
	if has_hat("vitality"):
		max_hp += 1
	# Apply hat Constitution
	if has_hat("constitution"):
		max_hp += 2
	
	set_hp(max_hp)

func check_upgrade(what: String):
	return upgrades.has(what) and upgrades[what]

func reset():
	set_hp(max_hp)
	velocity = Vector2()

func respawn():
	reset()
	Rooms.player_enter_room(check_pos)

func has_hat(id: String) -> bool:
	for i in hats:
		if i.id == id:
			return true
	return false

func has_available_hat(id: String) -> bool:
	for i in available_hats:
		if i.id == id:
			return true
	return false

func gain_hat(what: Hat):
	if !available_hats.has(what):
		available_hats.append(what)

func don_hat(what: Hat):
	var player = Game.get_player()
	var can_do: bool = true
	
	if is_instance_valid(player):
		player.pause_mode = PAUSE_MODE_PROCESS
		can_do = player.check_hat_viability(what)
	
	if can_do:
		if !hats.has(what):
			hats.append(what)
			apply_hats()
	
	if hats.size() >= 5:
		Game.achieve_cheeve("hatstack")
	
	if is_instance_valid(player):
		player.pause_mode = PAUSE_MODE_INHERIT
	return can_do

func doff_hat(what: Hat):
	var player = Game.get_player()
	
	if hats.has(what):
		hats.erase(what)
	
	apply_hats()

func apply_hats():
	var player = Game.get_player()
	if is_instance_valid(player):
		player.pause_mode = PAUSE_MODE_PROCESS
		player.apply_hat_visuals()
		player.apply_hats()
		
		max_hp = base_max_hp
		
		# Apply hat Vitality
		if has_hat("vitality"):
			max_hp += 1
		
		# Apply hat Constitution
		if has_hat("constitution"):
			max_hp += 2
		
		set_hp(hp)
		player.update_hp()
		
		player.pause_mode = PAUSE_MODE_INHERIT

func gain_upgrade(what: String):
	if !check_upgrade(what):
		upgrades[what] = true

func gain_lighter(what: int):
	if lighters.has(what):
		lighters[what] += 1
	else:
		lighters[what] = 1
	
	emit_signal("lighters_changed")

func consume_lighter(what: int) -> bool:
	if lighters.size() > what and lighters[what] > 0:
		lighters[what] -= 1
		used_lighters[what] += 1
		
		emit_signal("lighters_changed")
		return true
	return false

func add_kill(what: EnemyData):
	var id = what.id
	if kills.has(id):
		kills[id] += 1
	else:
		kills[id] = 1

func add_enemy_death(what: EnemyData):
	var id = what.id
	if enemy_deaths.has(id):
		enemy_deaths[id] += 1
	else:
		enemy_deaths[id] = 1

func get_kills(what: EnemyData):
	var id = what.id
	if kills.has(id):
		return kills[id]
	else:
		return 0

func get_enemy_deaths(what: EnemyData):
	var id = what.id
	if enemy_deaths.has(id):
		return enemy_deaths[id]
	else:
		return 0

func add_secret(what: String):
	if !secrets.has(what):
		secrets.append(what)
		
		if secrets.size() >= 3:
			Game.achieve_cheeve("secrets0")
		if secrets.size() >= 6:
			Game.achieve_cheeve("secrets1")
		
		emit_signal("secrets_changed")

func update_position():
	var player = Game.get_player()
	if is_instance_valid(player):
		position = Rooms.get_world_position(player.global_position)

func apply_position():
	if position != Vector2():
		Rooms.player_enter_room(position)
	else:
		Rooms.enter_room(Vector2(-16, -8))

func compress_data() -> Dictionary:
	var hat_ids = []
	for this_hat in hats:
		hat_ids.append(this_hat.resource_path)
	
	var available_hat_ids = []
	for this_hat in available_hats:
		available_hat_ids.append(this_hat.resource_path)
	
	var data = {
		"id": save_id,
		"lighters": lighters,
		"used_lighters": used_lighters,
		"hats": hat_ids,
		"available_hats": available_hat_ids,
		"upgrades": upgrades,
		"eyes": eyes,
		"hp": hp,
		"max_hp": max_hp,
		"vertices": vertices,
		"check_pos": check_pos,
		"extra_data": extra_data,
		"position": position,
		"main_music": main_music,
		"time": time,
		"kills": kills,
		"secrets": secrets,
		"cheeves": cheeves,
		"punches": punches,
		"sucker": sucker,
		"vertices_gained": vertices_gained,
		"deaths": deaths,
		"damage_taken": damage_taken,
	}
	
	return data

func uncompress_data(data: Dictionary):
	if data.has("id"): save_id = data["id"]
	lighters = data["lighters"]
	if data.has("used_lighters"):
		used_lighters = data["used_lighters"]
	var hat_ids = data["hats"]
	var available_hat_ids = data["available_hats"]
	upgrades = data["upgrades"]
	eyes = data["eyes"]
	hp = data["hp"]
	max_hp = data["max_hp"]
	set_vertices( data["vertices"] )
	check_pos = data["check_pos"]
	extra_data = data["extra_data"]
	position = data["position"]
	main_music = data["main_music"]
	time = data["time"]
	kills = data["kills"]
	
	hats = []
	for this_hat in hat_ids:
		hats.append(load(this_hat))
	
	available_hats = []
	for this_hat in available_hat_ids:
		available_hats.append(load(this_hat))
	
	if data.has("secrets"):
		secrets = data["secrets"]
	if data.has("cheeves"):
		cheeves = data["cheeves"]
	if data.has("punches"):
		punches = data["punches"]
	if data.has("sucker"):
		sucker = data["sucker"]
	if data.has("vertices_gained"):
		vertices_gained = data["vertices_gained"]
	if data.has("deaths"):
		deaths = data["deaths"]
	if data.has("damage_taken"):
		damage_taken = data["damage_taken"]
	
	while lighters.size() < 4:
		lighters.append(0)
	while used_lighters.size() < 4:
		used_lighters.append(0)

func reset_data():
	save_id = randi()
	lighters = [0, 0, 0, 0]
	used_lighters = [0, 0, 0, 0]
	hats = []
	available_hats = [preload("res://hats/0001_vitality.tres")]
	upgrades = {
		"blademaster_recover": false,
		"rapiers": false,
		"arrow_ladder": false,
		"fake_id": false,
	}
	eyes = EYES_BASIC
	max_hp = base_max_hp
	hp = base_max_hp
	vertices = 0
	check_pos = Vector2()
	extra_data = []
	position = Vector2()
	main_music = "ingress"
	time = 0
	kills = {}
	secrets = []
	cheeves = []
	punches = 0
	sucker = false


func _on_vertex_collected(what):
	set_vertices(vertices + int(what.value))
	vertices_gained += int(what.value)
	emit_signal("vertices_collected", what.value)
	
	if vertices_gained >= 300:
		Game.achieve_cheeve("wealth")
