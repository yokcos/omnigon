tool
extends Node2D


export (int) var size = 0 setget set_size
export (float) var angle = 90
export (float) var rotate_time = 2
export (float) var pause_time = 2
export (float) var phase = 0

var cycle_time: float = 4
var previous_angle: float = 0
var active: bool = false
var current_angle: float = 0

var textures: Array = [
	preload("res://props/rotator_small.png"),
	preload("res://props/rotator.png"),
]
var pieces: Array = []


func _ready() -> void:
	cycle_time = rotate_time + pause_time
	previous_angle = rotation_degrees
	current_angle = rotation_degrees
	register_pieces()

func _process(delta: float) -> void:
	if !Engine.editor_hint and active:
		phase += delta
		
		if phase < rotate_time:
			current_angle = previous_angle + (phase * angle / rotate_time)
			$sprite.rotation_degrees = current_angle
		else:
			current_angle = previous_angle + angle
			$sprite.rotation_degrees = current_angle
		
		while phase > cycle_time:
			phase -= cycle_time
			previous_angle = fposmod(previous_angle + angle, 360)
		
		rotate_pieces()


func rotate_pieces():
	for dict in pieces:
		dict["thing"].position = dict["position"].rotated( deg2rad(current_angle) )

func register_pieces():
	active = true
	
	for i in range(get_child_count()):
		var thing = get_child(i)
		var applicable: bool = true
		
		if thing == $sprite:
			applicable = false
		
		if thing is Node2D and applicable:
			var dict: Dictionary = {
				"thing": thing,
				"position": thing.position
			}
			pieces.append(dict)

func set_size(what: int):
	what = clamp(what, 0, 1)
	$sprite.texture = textures[what]
	
	size = what

