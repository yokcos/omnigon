extends StaticBody2D


const obj_block = preload("res://props/block_circle.tscn")


func get_shifted():
	queue_free()
	var new_block = obj_block.instance()
	Game.deploy_instance(new_block, position)
