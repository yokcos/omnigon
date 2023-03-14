extends Node2D


func _ready() -> void:
	if randf() < 0.5:
		$visual.scale.y = -1
