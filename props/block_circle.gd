extends RigidBody2D


func get_shifted():
	Game.replace_instance(self, load("res://props/block.tscn").instance())
