extends Area2D


var velocity: Vector2 = Vector2()
var duration: float = 10

const obj_explosion = preload("res://fx/explosion.tscn")


func _ready() -> void:
	explode()

func _process(delta: float) -> void:
	position += velocity * delta
	
	duration -= delta
	if duration <= 0:
		queue_free()


func explode():
	var new_explosion = obj_explosion.instance()
	Game.deploy_instance(new_explosion, global_position)


func _on_timer_timeout() -> void:
	explode()

func _on_explosion_wave_body_entered(body: Node) -> void:
	queue_free()
