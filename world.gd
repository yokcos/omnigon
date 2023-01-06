extends Node2D


func _ready() -> void:
	Game.set_world(self)


func deploy_instance(what: Node2D, where: Vector2):
	what.position = where
	add_child(what)
