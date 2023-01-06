class_name Enemy
extends Being


export (int) var sfx_set = 0
export (Resource) var enemy_data = null
var sfx_hit = []
var sfx_death = []


func take_damage(dmg: float, source: Being = null):
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
