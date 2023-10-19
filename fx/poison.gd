extends Node2D


func activate():
	poison()
	
	$animator.play("spray")
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_fart, global_position)

func poison():
	for i in $area.get_overlapping_bodies():
		if i is Being:
			i.poisoned = true
			i.take_damage(0)
			if i == Game.get_player():
				PlayerStats.hp = i.hp
