extends Node2D


var value: float = 1
var texture: Texture = null setget set_texture
var velocity: Vector2 = Vector2(0, -100)


func _process(delta: float) -> void:
	position += velocity * delta
	
	if position.y < 0:
		get_claimed()


func get_claimed():
	Events.emit_signal("fishticuffs_score_gained", value)
	
	queue_free()

func set_texture(what: Texture):
	texture = what
	$sprite.texture = what
