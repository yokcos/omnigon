extends Area2D


var musics = [
	{"music": GlobalSound.musics["the_second_disc_begins"], "animation": 0},
	{"music": GlobalSound.musics["facilitymechanism"], "animation": 1},
	{"music": GlobalSound.musics["suddenmimic"], "animation": 0},
	{"music": GlobalSound.musics["imperialsecrets"], "animation": 1},
	{"music": GlobalSound.musics["hallwayforeboding"], "animation": 0},
	{"music": GlobalSound.musics["timeforbattle"], "animation": 2},
	{"music": GlobalSound.musics["calamitymarch"], "animation": 2},
	{"music": GlobalSound.musics["thesecretsofspacetravel"], "animation": 1},
	{"music": GlobalSound.musics["gearsandclockwork"], "animation": 1},
	{"music": GlobalSound.musics["the_second_disc_ends"], "animation": 0},
]
var animations = ["calm", "gustoful", "frantic", "calmer"]

var current_music = 0


func _ready() -> void:
	if !match_music():
		play_music(0)
	
	$deets.rect_global_position.x = max($deets.rect_global_position.x, 8)


func match_music():
	var global_music: BGM = GlobalSound.current_music
	
	if !is_instance_valid(global_music):
		return false
	
	var id = global_music.title
	
	for i in range(musics.size()):
		var this_music = musics[i]
		if this_music["music"]["id"] == id:
			current_music = i
			play_music(current_music)
			return true
	return false

func play_music(what: int):
	var music = musics[what]["music"]
	GlobalSound.play_music(music["id"])
	$deets/list/upperbar/title.text = music["title"]
	$deets/list/upperbar/icon.texture = music["icon"]
	$deets/list/lore.text = music["lore"]
	
	$animator.stop()
	$animator.play(animations[ musics[what]["animation"] ])
	
	$deets/animator.play("arrive")

func get_shifted():
	pass


func _on_interactable_activated() -> void:
	current_music += 1
	current_music = posmod(current_music, musics.size())
	play_music(current_music)
