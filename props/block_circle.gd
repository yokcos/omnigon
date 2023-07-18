extends RigidBody2D


func get_shifted():
	var new_block = load("res://props/block.tscn").instance()
	Game.replace_instance(self, new_block)
	new_block.rotation = 0
