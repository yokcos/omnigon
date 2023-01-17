extends "res://rooms/room.gd"




func bossify_blademaster():
	for i in get_children():
		if i is Enemy:
			Game.set_boss(i)

