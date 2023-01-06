class_name SFX
extends AudioStreamPlayer


export var relative_volume : float = 1 setget set_relative_volume

func _ready() -> void:
	volumify()
	connect("finished", self, "_on_finished")
	play()


func volumify():
	var input = relative_volume * Settings.volume_sfx
	
	if input > 0:
		var x = input*input
		var decibels = 10 * log(x) / log(10)
		
		volume_db = decibels
	else:
		volume_db = -1000000

func randomise_pitch(minimum, maximum):
	pitch_scale = rand_range( minimum, maximum )



func set_relative_volume(what):
	relative_volume = what
	volumify()

func _on_finished():
	stop()
	queue_free()
