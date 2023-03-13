extends "res://projectiles/bullet.gd"


var fulcrum: Vector2 = Vector2()
var distance: float = 96
var age: float = 0


func _process(delta: float) -> void:
	reposition()


func reposition():
	global_position = fulcrum + Vector2(0, -distance).rotated(sin(age/PI))
