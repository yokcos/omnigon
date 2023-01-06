class_name SFX2D
extends AudioStreamPlayer2D


var player: KinematicBody2D = null
var host: Node2D = null

export var relative_volume : float = 1 setget set_relative_volume


func _ready() -> void:
	connect("finished", self, "_on_finished")
	play()


func reposition():
	position -= get_player_position()

func get_player_position() -> Vector2:
	
	if !is_instance_valid(player):
		player = Game.get_player()
	
	if is_instance_valid(player):
		if Game.camera and player:
			return player.position - Game.camera.get_actual_position()
	
	return Vector2()

func randomise_pitch(minimum, maximum):
	pitch_scale = rand_range( minimum, maximum )

func volumify():
	var input = relative_volume * Settings.volume_sfx
	
	if input > 0:
		var x = input*input
		var decibels = 10 * log(x) / log(10)
		
		volume_db = decibels
	else:
		volume_db = -1000000



func set_relative_volume(what):
	relative_volume = what
	volumify()

func _on_finished():
	stop()
	queue_free()
	
	#var relative = Game.camera.get_actual_position() - position
	#var i: float = 0
	#while i <= 1:
	#	Game.deploy_fx(load("res://vertex.png"), position + relative*i)
	#	i += 0.1
