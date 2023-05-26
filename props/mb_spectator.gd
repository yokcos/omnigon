extends Node2D


var textures: Array = [
	preload("res://props/mb_spectator_bm0.png"),
	preload("res://props/mb_spectator_bm1.png"),
	preload("res://props/mb_spectator_bm2.png"),
	preload("res://props/mb_spectator_bm3.png"),
]
var frameses: Array = [2, 2, 2, 2]


func _ready() -> void:
	var index = randi() % textures.size()
	$sprite.texture = textures[index]
	$sprite.hframes = frameses[index]
	$sprite.animation_speed = rand_range(2, 5)
