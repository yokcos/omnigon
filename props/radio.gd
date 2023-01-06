extends Area2D


var musics = [
	{"music": GlobalSound.musics["the_first_disc_begins"], "animation": 0},
	{"music": GlobalSound.musics["prelude"], "animation": 0},
	{"music": GlobalSound.musics["ingress"], "animation": 1},
	{"music": GlobalSound.musics["notweird"], "animation": 0},
	{"music": GlobalSound.musics["entrydenied"], "animation": 2},
	{"music": GlobalSound.musics["behold"], "animation": 3},
	{"music": GlobalSound.musics["great_opposition"], "animation": 2},
	{"music": GlobalSound.musics["shut_down"], "animation": 0},
	{"music": GlobalSound.musics["ingressment"], "animation": 1},
	{"music": GlobalSound.musics["the_first_disc_ends"], "animation": 0},
]
var animations = ["calm", "gustoful", "frantic", "calmer"]

var current_music = 0


func _ready() -> void:
	play_music(0)


func play_music(what: int):
	var music = musics[what]["music"]
	GlobalSound.play_temp_music(music["id"])
	$deets/list/upperbar/title.text = music["title"]
	$deets/list/upperbar/icon.texture = music["icon"]
	$deets/list/lore.text = music["lore"]
	
	$animator.stop()
	$animator.play(animations[ musics[what]["animation"] ])
	
	$deets/animator.play("arrive")

func get_shifted():
	var new_castle = load("res://props/bouncycastle.tscn").instance()
	Game.replace_instance(self, new_castle)


func _on_interactable_activated() -> void:
	current_music += 1
	current_music = posmod(current_music, musics.size())
	play_music(current_music)
