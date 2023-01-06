extends Enemy


var obj_blademaster = load("res://entities/enemies/blademaster.tscn")


func get_shifted():
	Game.replace_instance(self, obj_blademaster.instance())
