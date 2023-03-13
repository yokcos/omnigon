extends "res://projectiles/bullet.gd"


var fulcrum: Vector2 = Vector2()
var distance: float = 96
var age: float = 0
var swing_factor: float = 5*PI/4


func _process(delta: float) -> void:
	age += delta
	
	reposition()


func reposition():
	var offset = Vector2(0, distance).rotated(sin( age*swing_factor ))
	global_position = fulcrum + offset
	$line.points[1] = -offset
