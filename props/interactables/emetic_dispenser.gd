extends Node2D


var regurgitator: Node2D

const obj_emetic = preload("res://fx/emetic.tscn")


func get_shifted():
	scale.x *= -1

func _on_interactable_activated() -> void:
	var new_emetic = obj_emetic.instance()
	Game.deploy_instance(new_emetic, $barrel.global_position)
	new_emetic.linear_velocity = Vector2(-100, 0) * scale
	new_emetic.connect("acided", regurgitator, "activate")
