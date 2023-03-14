extends Node2D


func _ready() -> void:
	if randf() < 0.5:
		$visual.scale.y = -1


func _on_sprite_finished() -> void:
	$visual/sprite.hide()
	queue_free()
