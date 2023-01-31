extends "res://entities/upgrade.gd"


func activate():
	.activate()
	
	Game.summon_popup("Arrow of Ladders", Game.replace_input_string("You have now become the CLIMBLORD OF LADDERCRAFT!\nPress {move_up} and {shift} to cast your amazing spells of woodworking!"))
