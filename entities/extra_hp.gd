extends Node2D


export (float) var damage_per_hit = 8

var target: Being = null setget set_target
var pos: int = 0 setget set_pos
var spacing: float = 24
var base_bar: Control = null setget set_base_bar
var extra_damage: float = 0 setget set_extra_damage
var all_bars: Array = []
var extra_velocity: Vector2 = Vector2()
var egressing: bool = false
var egress_duration: float = 10

var invuln: float = 0
export (float) var invuln_duration = 0.2


func _ready() -> void:
	$boss_bar.hide_text()

func _process(delta: float) -> void:
	if egressing:
		rotation += 5 * delta
		egress_duration -= delta
		if egress_duration <= 0:
			queue_free()
	else:
		if is_instance_valid(base_bar):
			drift_to_base(delta)
		
		extra_velocity -= extra_velocity * delta*10
	
	position += extra_velocity * delta
	
	if invuln > 0:
		invuln -= delta
		if invuln <= 0:
			$damage_flash.hide()


func drift_to_base(delta: float):
	var target_pos: Vector2
	if pos == 0:
		target_pos = base_bar.rect_global_position + base_bar.rect_size/2
		target_pos += Game.camera.get_visible_rect().position
		target_pos -= Game.gameholder.get_node("beholder").rect_position
	else:
		target_pos = all_bars[pos - 1].global_position
	target_pos.y -= spacing
	
	var target_rotation = (global_position.x - target_pos.x) / 400
	rotation = lerp(rotation, target_rotation, delta*5)
	global_position = global_position.linear_interpolate(target_pos, delta*8)
	
	$boss_bar.rect_position = -base_bar.rect_size/2
	$boss_bar.rect_size = base_bar.rect_size

func snap_to_base():
	if is_instance_valid(base_bar):
		var target_pos: Vector2
		target_pos = base_bar.rect_global_position + base_bar.rect_size/2
		target_pos += Game.camera.get_visible_rect().position
		target_pos -= Game.gameholder.get_node("beholder").rect_position
		global_position = target_pos

func take_damage(what: float):
	set_extra_damage(extra_damage + what)

func get_culled():
	if !egressing:
		for i in all_bars:
			if i != self and !i.is_queued_for_deletion() and is_instance_valid(i):
				#i.all_bars.erase(self)
				if i.pos > pos:
					i.pos -= 1
		
		all_bars.erase(self)
		
		if is_instance_valid(target):
			target.call_deferred("take_damage", target.max_hp)
		
		egressing = true


func set_pos(what: int):
	pos = what
	
	$boss_bar.start_hp = target.max_hp * (what + 1)

func set_target(what: Being):
	target = what
	
	$boss_bar.target = what

func set_base_bar(what: Control):
	base_bar = what
	
	$punch_detector/hitbox.shape.extents = base_bar.rect_size/2
	$damage_flash.rect_size = base_bar.rect_size + Vector2(4, 4)
	$damage_flash.rect_position = -base_bar.rect_size/2 - Vector2(2, 2)

func set_extra_damage(what: float):
	extra_damage = what
	$boss_bar.extra_hp = -what


func _on_punch_detector_punched() -> void:
	take_damage(damage_per_hit)
	
	invuln = invuln_duration
	$damage_flash.show()
	
	rotation += rand_range(-2, 2)
	var dir: int
	var player: Being = Game.get_player()
	if is_instance_valid(player):
		dir = player.flip_int
		extra_velocity.x += dir * 1000
		extra_velocity.y += rand_range(-400, 400)

func _on_boss_bar_filling_changed(what: float) -> void:
	if what <= 0:
		get_culled()
