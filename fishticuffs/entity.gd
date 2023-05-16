class_name FishticuffsEntity
extends KinematicBody2D


var velocity: Vector2 = Vector2()
var acceleration: float = 1000
var max_speed: float = 100
var friction: float = 10
var hp: int = 3


func _physics_process(delta: float) -> void:
	frictutate(delta)
	
	velocity = move_and_slide(velocity)


func frictutate(delta: float):
	velocity -= velocity * friction * delta
