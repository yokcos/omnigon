extends Node2D


export (float) var damage_per_hit = 8

var target: Being = null setget set_target
var pos: int = 0 setget set_pos
var spacing: float = 24
var base_bar: Control = null setget set_base_bar
var extra_damage: float = 0 setget set_extra_damage
var all_bars: Array = []

var invuln: float = 0
export (float) var invuln_duration = 0.2


func _ready() -> void:
	$boss_bar.hide_text()

func _process(delta: float) -> void:
	if is_instance_valid(base_bar):
		var target_pos: Vector2
		if pos == 0:
			target_pos = base_bar.rect_global_position + base_bar.rect_size/2
			target_pos += Game.camera.get_visible_rect().position
			target_pos -= Game.gameholder.get_node("beholder").rect_position
		else:
			target_pos = all_bars[pos - 1].global_position
		target_pos.y -= spacing
		
		rotation = (global_position.x - target_pos.x) / 400
		global_position = global_position.linear_interpolate(target_pos, delta*5)
		
		$boss_bar.rect_position = -base_bar.rect_size/2
		$boss_bar.rect_size = base_bar.rect_size
	
	if invuln > 0:
		invuln -= delta
		if invuln <= 0:
			$damage_flash.hide()


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
	for i in all_bars:
		if i != self and !i.is_queued_for_deletion() and is_instance_valid(i):
			i.all_bars.erase(self)
			if i.pos > pos:
				i.pos -= 1
	
	if is_instance_valid(target):
		target.take_damage(target.max_hp)
	
	queue_free()


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

func _on_boss_bar_filling_changed(what: float) -> void:
	if what <= 0:
		get_culled()
