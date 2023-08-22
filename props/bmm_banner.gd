extends Node2D


export (int) var sprite = 0

const sprites = [
	preload("res://props/bmm_banner_blade.png"),
	preload("res://props/bmm_banner_bm.png"),
]


func _ready() -> void:
	$sprite.texture = sprites[sprite]
