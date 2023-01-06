extends "res://projectiles/bullet.gd"


var jerk: Vector2 = Vector2(-100, 0)


func _ready() -> void:
	add_to_group("snots")

func _process(delta: float) -> void:
	acceleration += jerk*delta


