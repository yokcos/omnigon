class_name BGM
extends AudioStreamPlayer


var fade_in_time: float = 0
var fade_out_time: float = 0

var min_volume: float = -40
var target_volume: float = 0
var title: String = ""

enum states {
	FADE_IN,
	MAIN,
	FADE_OUT,
}
var state = states.FADE_IN


func _init() -> void:
	bus = "Music"
	if fade_in_time > 0:
		set_state(states.FADE_IN)
	else:
		set_state(states.MAIN)

func _ready() -> void:
	play()
	Settings.connect("volume_music_changed", self, "_on_volume_music_changed")


func get_actual_target() -> float:
	if Settings.volume_music <= 0:
		return -1000.0
	var result = min_volume + (target_volume - min_volume) * Settings.volume_music
	return result

func set_state(what: int):
	match what:
		states.FADE_IN:
			volume_db = min_volume
			
			var tween = Tween.new()
			tween.interpolate_property(
				self, "volume_db",
				min_volume, get_actual_target(),
				fade_in_time, Tween.TRANS_QUART, Tween.EASE_OUT
			)
			add_child(tween)
			tween.connect("tween_all_completed", self, "_on_fade_in_complete")
			tween.call_deferred("start")
		
		states.MAIN:
			volume_db = get_actual_target()
		
		states.FADE_OUT:
			var tween = Tween.new()
			tween.interpolate_property(
				self, "volume_db",
				get_actual_target(), min_volume,
				fade_out_time, Tween.TRANS_QUART, Tween.EASE_IN
			)
			add_child(tween)
			tween.connect("tween_all_completed", self, "_on_fade_out_complete")
			tween.call_deferred("start")

func fade_out():
	set_state(states.FADE_OUT)

func mute():
	volume_db = -1000

func unmute():
	volume_db = get_actual_target()


func _on_fade_in_complete():
	set_state(states.MAIN)

func _on_fade_out_complete():
	queue_free()

func _on_volume_music_changed():
	volume_db = get_actual_target()
