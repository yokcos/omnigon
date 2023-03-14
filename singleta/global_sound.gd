extends Node


var current_music: BGM = null
var temp_music: BGM = null
var ear: Listener2D = null

const obj_transient_sfx = preload("res://sfx/transient_sfx.tscn")
const obj_locational_sfx = preload("res://sfx/locational_sfx.tscn")

const sfx_vertex_hit = [
	preload("res://sfx/coins1_0.wav"),
	preload("res://sfx/coins1_1.wav"),
	preload("res://sfx/coins1_2.wav"),
	preload("res://sfx/coins1_3.wav"),
]
const sfx_vertex_grab = [
	preload("res://sfx/coins0_0.wav"),
	preload("res://sfx/coins0_1.wav"),
	preload("res://sfx/coins0_2.wav"),
	preload("res://sfx/coins0_3.wav"),
]
const sfx_fart = [
	preload("res://sfx/farts0_0.wav"),
	preload("res://sfx/farts0_1.wav"),
	preload("res://sfx/farts0_2.wav"),
]
const sfx_step = [
	preload("res://sfx/hits0_step0.wav"),
	preload("res://sfx/hits0_step1.wav"),
	preload("res://sfx/hits0_step2.wav"),
	preload("res://sfx/hits0_step3.wav"),
	preload("res://sfx/hits0_step4.wav"),
	preload("res://sfx/hits0_step5.wav"),
]
const sfx_land = [
	preload("res://sfx/hits0_land0.wav"),
	preload("res://sfx/hits0_land1.wav"),
	preload("res://sfx/hits0_land2.wav"),
]
const sfx_climb = [
	preload("res://sfx/clack0_0.wav"),
	preload("res://sfx/clack0_1.wav"),
	preload("res://sfx/clack0_2.wav"),
	preload("res://sfx/clack0_3.wav"),
	preload("res://sfx/clack0_4.wav"),
	preload("res://sfx/clack0_5.wav"),
]
const sfx_jump = [preload("res://entities/jump.wav")]
const sfx_shift = [preload("res://entities/shift.wav")]
const sfx_whoosh = [preload("res://sfx/whoosh0.wav")]
const sfx_whoosh_charge = [preload("res://sfx/whoosh_charge.wav")]
const sfx_whoosh_bang = [preload("res://sfx/whoosh_bang.wav")]
const sfx_pop = [
	preload("res://sfx/pop0.wav"),
	preload("res://sfx/pop1.wav"),
	preload("res://sfx/pop2.wav"),
]
const sfx_bleh = [
	preload("res://sfx/bleh0.wav"),
	preload("res://sfx/bleh1.wav"),
	preload("res://sfx/bleh2.wav"),
	preload("res://sfx/bleh3.wav"),
]
const sfx_blast = [preload("res://sfx/blast0.wav")]
const sfx_blast_large = [preload("res://sfx/blast_large.wav")]
const sfx_blap = [preload("res://sfx/blap.wav")]
const sfx_spring = [preload("res://sfx/spring.wav")]
const sfx_boing = [preload("res://sfx/boing.wav")]
const sfx_weewoo = [preload("res://props/interactables/weewoo.wav")]

const sfx_blademaster_fall = [preload("res://entities/enemies/blademaster_fall.wav")]
const sfx_bouncer_bounce = [preload("res://entities/enemies/bouncer_bounce.wav")]
const sfx_sneeze = [
	preload("res://sfx/sneeze0.wav"),
	preload("res://sfx/sneeze1.wav"),
]
const sfx_player_hit = [preload("res://entities/player_hit.wav")]
const sfx_player_death = [preload("res://entities/player_death.wav")]
const sfx_enemy_hit = [preload("res://entities/enemy_hit.wav")]
const sfx_enemy_death = [preload("res://entities/enemy_death.wav")]

const sfx_eyesaac_charge = [preload("res://entities/enemies/eyesaac_charge.wav")]
const sfx_eyesaac_laser = [preload("res://entities/enemies/eyesaac_laser.wav")]
const sfx_eyesaac_laser_shoot = [preload("res://entities/enemies/eyesaac_laser_shoot.wav")]
const sfx_eyesaac_shoot = [
	preload("res://entities/enemies/eyesaac_shoot0.wav"),
	preload("res://entities/enemies/eyesaac_shoot1.wav"),
	preload("res://entities/enemies/eyesaac_shoot2.wav"),
	]
const sfx_eyesaac_slam = [preload("res://entities/enemies/eyesaac_slam.wav")]

const sfx_pot_break_a = [
	preload("res://props/pot_break0.wav"),
	preload("res://props/pot_break1.wav"),
	preload("res://props/pot_break2.wav"),
]
const sfx_pot_break_b = [
	preload("res://props/pot_break3.wav"),
	preload("res://props/pot_break4.wav"),
	preload("res://props/pot_break5.wav"),
]
const sfx_automaton_recharge = [preload("res://entities/enemies/automaton_recharge.wav")]
const sfx_automaton_turn = [preload("res://entities/enemies/automaton_turn.wav")]
const sfx_tick = [
	preload("res://sfx/tick0.wav"),
	preload("res://sfx/tick1.wav"),
	preload("res://sfx/tick2.wav"),
]
const sfx_tock = [
	preload("res://sfx/tock0.wav"),
	preload("res://sfx/tock1.wav"),
	preload("res://sfx/tock2.wav"),
]
const sfx_bong = [preload("res://entities/enemies/bong.wav")]
const sfx_ring = [preload("res://entities/enemies/ring.wav")]
const sfx_target = [preload("res://entities/enemies/target.wav")]
const sfx_whomp = [preload("res://sfx/whomp.wav")]

const sfx_DT = [preload("res://ui/DT_Shoot3.wav")]
const sfx_introduce = [preload("res://ui/DT_hurt.wav")]

var musics: Dictionary = {
	"the_first_disc_begins": preload("res://music/disc1/the_first_disc_begins.ogg"),
	"prelude": preload("res://music/disc1/prelude.ogg"),
	"ingress": preload("res://music/disc1/ingress.ogg"),
	"notweird": preload("res://music/disc1/notweird.ogg"),
	"entrydenied": preload("res://music/disc1/entrydenied.ogg"),
	"behold": preload("res://music/disc1/behold.ogg"),
	"great_opposition": preload("res://music/disc1/great_opposition.ogg"),
	"shut_down": preload("res://music/disc1/shut_down.ogg"),
	"ingressment": preload("res://music/disc1/ingressment.ogg"),
	"the_first_disc_ends": preload("res://music/disc1/the_first_disc_ends.ogg"),
	
	"facilitymechanism": preload("res://music/disc2/0001_facilitymechanism.ogg"),
	"suddenmimic": preload("res://music/disc2/0002_suddenmimic.ogg"),
	"imperialsecrets": preload("res://music/disc2/0003_imperialsecrets.ogg"),
	"hallwayforeboding": preload("res://music/disc2/0004_hallwayforeboding.ogg"),
}
var discs = [
	[
		"the_first_disc_begins",
		"prelude",
		"ingress",
		"notweird",
		"entrydenied",
		"behold",
		"great_opposition",
		"shut_down",
		"ingressment",
		"the_first_disc_ends",
	],
	[
		"facilitymechanism",
		"suddenmimic",
	]
]


func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	ear = Listener2D.new()
	ear.make_current()
	add_child(ear)
	
	add_music_entry(preload("res://music/disc1/the_first_disc_begins.tres"))
	add_music_entry(preload("res://music/disc1/prelude.tres"))
	add_music_entry(preload("res://music/disc1/ingress.tres"))
	add_music_entry(preload("res://music/disc1/notweird.tres"))
	add_music_entry(preload("res://music/disc1/entrydenied.tres"))
	add_music_entry(preload("res://music/disc1/behold.tres"))
	add_music_entry(preload("res://music/disc1/great_opposition.tres"))
	add_music_entry(preload("res://music/disc1/shut_down.tres"))
	add_music_entry(preload("res://music/disc1/ingressment.tres"))
	add_music_entry(preload("res://music/disc1/the_first_disc_ends.tres"))
	
	add_music_entry(preload("res://music/disc2/0001_facilitymechanism.tres"))
	add_music_entry(preload("res://music/disc2/0002_suddenmimic.tres"))
	add_music_entry(preload("res://music/disc2/0003_imperialsecrets.tres"))
	add_music_entry(preload("res://music/disc2/0004_hallwayforeboding.tres"))


func add_music_entry(what: Music):
	var dict = {
		"id": what.id,
		"title": what.title,
		"audio": what.audio,
		"icon": what.icon,
		"lore": what.lore,
	}
	musics[what.id] = dict

func get_music(what: String) -> BGM:
	if what == "":
		return null
	
	#var audio: AudioStream = load("res://music/%s.ogg" % what)
	var audio: AudioStream = musics[what]["audio"]
	var new_bgm = BGM.new()
	new_bgm.stream = audio
	return new_bgm

func silence_music():
	if is_instance_valid(current_music):
		current_music.fade_out()

func play_music(what: String, roomish = true):
	cut_temp_music()
	
	if is_instance_valid(current_music):
		if current_music.title == what:
			return false
		current_music.fade_out()
		current_music = null
	
	var new_bgm = get_music(what)
	
	current_music = new_bgm
	new_bgm.title = what
	add_child(new_bgm)
	
	if temp_music:
		new_bgm.stop()
	
	if roomish:
		PlayerStats.main_music = what

func resume_music():
	cut_temp_music()
	var main_music = PlayerStats.main_music
	if main_music:
		play_music(main_music)

func cut_temp_music():
	if temp_music:
		temp_music.fade_out()
		temp_music = null

func play_temp_music(what):
	silence_music()
	
	if temp_music:
		if temp_music.title == what:
			return false
		temp_music.fade_out()
		temp_music = null
	
	var new_bgm = get_music(what)
	
	temp_music = new_bgm
	new_bgm.title = what
	add_child(new_bgm)

func play_random_sfx(what: Array):
	var index = randi() % what.size()
	return play_sfx(what[index])

func play_sfx(what: AudioStream):
	var new_sfx: SFX = obj_transient_sfx.instance()
	new_sfx.stream = what
	add_child(new_sfx)
	
	return new_sfx

func play_random_sfx_2d(what: Array, where: Vector2):
	var index = randi() % what.size()
	return play_sfx_2d(what[index], where)

func play_sfx_2d(what: AudioStream, where: Vector2):
	var new_sfx: SFX2D = obj_locational_sfx.instance()
	new_sfx.global_position = where
	new_sfx.stream = what
	#new_sfx.reposition()
	add_child(new_sfx)
	
	return new_sfx
