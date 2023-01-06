class_name Projectile
extends Area2D
 
 
var velocity: Vector2 = Vector2()
var duration: float = 20
var damage: float = 1
var penetrations: float = 0
var exceptions: Array = []
 
 
 
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
 
func _process(delta: float) -> void:
	position += velocity * delta
	
	duration -= delta
	if duration <= 0:
		queue_free()
 
 
 
func _on_body_entered(body):
	if body is Being and !body in exceptions:
		body.take_damage(damage)
		queue_free()
