extends Node2D


export (Vector2) var destination = Vector2()

var active = false
const obj_hp = preload("res://animations/moneybags_health/hp.tscn")


func _process(delta: float) -> void:
	if active and randf()*2 < 1:
		var new_hp = obj_hp.instance()
		new_hp.destination = destination
		add_child(new_hp)

func activate():
	active = true
