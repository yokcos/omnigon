class_name Projectile
extends Area2D
 
 
var velocity: Vector2 = Vector2()
var acceleration: Vector2 = Vector2()
var duration: float = 20
var damage: float = 1
var penetrations: float = 0
var exceptions: Array = []
var source: Node = null
 
 
 
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	add_to_group("projectiles")
 
func _process(delta: float) -> void:
	velocity += acceleration * delta
	position += velocity * delta
	
	duration -= delta
	if duration <= 0:
		queue_free()
 

func hit(what: Being):
	what.take_damage(damage, source)
	
	penetrations -= 1
	if penetrations < 0:
		queue_free()
 
 
func _on_body_entered(body):
	if body is Being and !body in exceptions:
		hit(body)
