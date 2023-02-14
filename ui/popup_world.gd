extends "res://ui/popup_parent.gd"


var scale = 2
var base_size: Vector2 = Vector2(268, 220)


func _ready() -> void:
	$worldholder/port.size = base_size * scale
	$worldholder.rect_scale = Vector2(1, 1) / scale


func apply_world(world: PackedScene):
	var new_world = world.instance()
	$worldholder/port.add_child(new_world)

func egress():
	$animator.play("depart")

