extends "res://ui/popup_parent.gd"


var scale = 2
var base_size: Vector2 = Vector2(268, 220)


signal world_slain


func _ready() -> void:
	$worldholder/port.size = base_size * scale
	$worldholder.rect_scale = Vector2(1, 1) / scale


func set_title(what: String):
	window_title = what

func apply_world(world: PackedScene):
	var new_world = world.instance()
	$worldholder/port.add_child(new_world)
	
	new_world.connect("tree_exiting", self, "_on_world_slain")

func egress():
	$animator.play("depart")


func _on_world_slain():
	emit_signal("world_slain")
	egress()

