extends Node2D


var base_frame: float = 0
var animation_speed: float = 20
var frames_per_animation: int = 8
var current_animation: int = 0
var animations: int = 6
var room_centre: Vector2 = Vector2(2176, 128)
var age: float = 0
var duration: float = 76.8
var strike_duration: float = 3.2
var struck: bool = false
var retreating: bool = false

var base_size: float = 2
var distance: float = 0.01
var motion_scale: float = 0.01
var distances: Array = []


func _ready() -> void:
	GlobalSound.play_temp_music("calamitymarch")
	
	room_centre = get_parent().global_position

func _process(delta: float) -> void:
	if retreating:
		age -= delta * 50
		if age < 0:
			queue_free()
	else:
		age += delta
	
	base_frame += delta * animation_speed
	base_frame = fposmod(base_frame, frames_per_animation)
	$visual/sprite.frame = int(base_frame) + current_animation * frames_per_animation
	var next_animation = min(current_animation + 1, animations-1)
	$visual/sprite2.frame = int(base_frame) + next_animation * frames_per_animation
	var animation_duration = duration / float(animations)
	var animation_progress = fmod(age, animation_duration) / animation_duration
	$visual/sprite2.material.set_shader_param("factor", animation_progress)
	
	var ratio: float = age/duration
	ratio = clamp(ratio, 0, 0.9999)
	distance = lerp(2, 0, ratio)
	motion_scale = pow(2, -distance)
	var size: float = motion_scale * base_size
	
	current_animation = int(ratio*6)
	scale = Vector2( size, size )
	
	var cam = Game.camera
	var player = Game.get_player()
	
	var passed_layers: int = 0
	for i in distances:
		if distance < i:
			passed_layers += 1
	z_index = passed_layers
	
	if is_instance_valid(cam) and is_instance_valid(player):
		var central_pos: Vector2 = cam.get_actual_position()
		var target_pos: Vector2 = cam.get_actual_position()
		target_pos.y = get_parent().global_position.y
		
		if age >= duration - strike_duration:
			var this_factor: float = age - (duration-strike_duration)
			this_factor /= strike_duration
			this_factor = clamp(this_factor, 0, 1)
			target_pos.x = lerp(target_pos.x, player.global_position.x, this_factor)
		
		global_position = central_pos.linear_interpolate( target_pos, motion_scale )
		
		if age >= duration - strike_duration and !struck:
			struck = true
			$animator.play("strike")
		
		if age >= duration:
			player.die()


func retreat():
	retreating = true

func cull():
	GlobalSound.play_music("433")
