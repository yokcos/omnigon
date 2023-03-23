extends Node2D


var base_frame: float = 0
var animation_speed: float = 10
var frames_per_animation: int = 4
var current_animation: int = 0
var animations: int = 6
var room_centre: float = 2176
var motion_scale: float = 0.01
var age: float = 0
var duration: float = 76.8
var strike_duration: float = 3.2
var struck: bool = false
var retreating: bool = false


func _ready() -> void:
	GlobalSound.play_temp_music("calamitymarch")

func _process(delta: float) -> void:
	if retreating:
		age -= delta * 50
		if age < 0:
			queue_free()
	else:
		age += delta
	
	base_frame += delta * animation_speed
	base_frame = fposmod(base_frame, 4)
	$visual/sprite.frame = int(base_frame) + current_animation * frames_per_animation
	var next_animation = min(current_animation + 1, animations-1)
	$visual/sprite2.frame = int(base_frame) + next_animation * frames_per_animation
	var animation_duration = duration / float(animations)
	var animation_progress = fmod(age, animation_duration) / animation_duration
	$visual/sprite2.material.set_shader_param("factor", animation_progress)
	
	var ratio: float = age/duration
	ratio = clamp(ratio, 0, 0.9999)
	motion_scale = lerp( 0.01, 1, ratio )
	current_animation = int(ratio*6)
	var size: float = lerp( 0.5, 2, sqrt(ratio) )
	scale = Vector2( size, size )
	
	var cam = Game.camera
	var player = Game.get_player()
	
	if motion_scale > 0.1:
		z_index = -get_parent().z_index - 21
	
	if is_instance_valid(cam) and is_instance_valid(player):
		var pos: Vector2 = cam.get_actual_position()
		var offset: float = pos.x - room_centre
		var relative: float = offset
		
		if age >= duration - strike_duration:
			var this_factor: float = age - (duration-strike_duration)
			this_factor /= strike_duration
			this_factor = clamp(this_factor, 0, 1)
			var p_relative = player.global_position.x - room_centre
			relative = lerp(relative, p_relative, this_factor)
		
		global_position.x = pos.x + (relative - offset) * motion_scale
		
		if age >= duration - strike_duration and !struck:
			struck = true
			$animator.play("strike")
		
		if age >= duration:
			player.die()


func retreat():
	retreating = true

func cull():
	GlobalSound.play_music("433")
