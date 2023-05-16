class_name Enemy
extends Being


export (int) var sfx_set = 0
export (Resource) var enemy_data = null
var sfx_hit = []
var sfx_death = []
var hits: int = 0
var most_recent_hit: int = 0


func _ready() -> void:
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(2, true)


func take_damage(dmg: float, source: Being = null):
	if source == Game.get_player():
		hits += 1
		most_recent_hit = OS.get_ticks_msec()
	
	var actual_dmg = .take_damage(dmg, source)
	
	var new_sfx: SFX2D = null
	if sfx_hit == []:
		new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_enemy_hit, global_position)
	else:
		new_sfx = GlobalSound.play_random_sfx_2d(sfx_hit, global_position)
	
	if new_sfx:
		new_sfx.relative_volume = 0.6
	
	return actual_dmg


func die():
	.die()
	
	if enemy_data is EnemyData:
		PlayerStats.add_enemy_death(enemy_data)
		if most_recent_hit > OS.get_ticks_msec()-50:
			PlayerStats.add_kill(enemy_data)
	
	var new_sfx: SFX2D = null
	if sfx_death == []:
		new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_enemy_death, global_position)
	else:
		new_sfx = GlobalSound.play_random_sfx_2d(sfx_death, global_position)
	
	if new_sfx:
		new_sfx.relative_volume = 0.6
	
	if Game.current_boss == self:
		WorldSaver.add_data("bosses_defeated", 1)
