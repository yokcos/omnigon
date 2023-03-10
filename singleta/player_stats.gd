extends Node

enum {
	EYES_NONE,
	EYES_BASIC,
	EYES_SHAPESHIFTER,
}

enum {
	LIGHTER_PLAIN,
	LIGHTER_SOPHISTICATED,
}

var base_max_hp: float = 3
var max_hp: float = base_max_hp
var hp: float = base_max_hp setget set_hp
var vertices: int = 0 setget set_vertices
var position: Vector2 = Vector2()
var velocity: Vector2 = Vector2()
var eyes: int = EYES_BASIC setget set_eyes
var check_pos: Vector2 = Vector2()
var extra_data: Array = []
var lighters: Array = [0]
var main_music: String = "ingress"
var time: float = 0

var upgrades: Dictionary = {
	"blademaster_recover": false,
	"arrow_ladder": false,
	"fake_id": false,
}

var available_hats: Array = [
	preload("res://hats/0001_vitality.tres"),
]
var hats: Array = []
var kills: Dictionary = {}
var secrets: Array = []


signal eyes_changed
signal hp_changed
signal vertices_changed
signal vertices_collected
signal hats_changed


func _process(delta: float) -> void:
	if Game.in_game:
		time += delta


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

func gain_hat(what: Hat):
	if !available_hats.has(what):
		available_hats.append(what)

func gain_upgrade(what: String):
	if !check_upgrade(what):
		upgrades[what] = true

func gain_lighter(what: int):
	if lighters.has(what):
		lighters[what] += 1
	else:
		lighters[what] = 1

func consume_lighter(what: int) -> bool:
	if lighters.size() > what and lighters[what] > 0:
		lighters[what] -= 1
		return true
	return false

func add_kill(what: EnemyData):
	var id = what.id
	if kills.has(id):
		kills[id] += 1
	else:
		kills[id] = 1

func get_kills(what: EnemyData):
	var id = what.id
	if kills.has(id):
		return kills[id]
	else:
		return 0

func add_secret(what: String):
	if !secrets.has(what):
		secrets.append(what)

func update_position():
	var player = Game.get_player()
	if is_instance_valid(player):
		position = Rooms.get_world_position(player.global_position)

func apply_position():
	if position != Vector2():
		Rooms.player_enter_room(position)
	else:
		Rooms.enter_room(Vector2())

func compress_data() -> Dictionary:
	var hat_ids = []
	for this_hat in hats:
		hat_ids.append(this_hat.resource_path)
	
	var available_hat_ids = []
	for this_hat in available_hats:
		available_hat_ids.append(this_hat.resource_path)
	
	var data = {
		"lighters": lighters,
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
	}
	
	return data

func uncompress_data(data: Dictionary):
	lighters = data["lighters"]
	var hat_ids = data["hats"]
	var available_hat_ids = data["available_hats"]
	upgrades = data["upgrades"]
	eyes = data["eyes"]
	hp = data["hp"]
	max_hp = data["max_hp"]
	vertices = data["vertices"]
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


func _on_vertex_collected(quantity: float):
	set_vertices(vertices + int(quantity))
	emit_signal("vertices_collected", quantity)
