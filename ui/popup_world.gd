extends "res://ui/popup_parent.gd"


var scale = 2
var base_size: Vector2 = Vector2(268, 220)
var world: Node = null


signal world_slain


func _ready() -> void:
	$worldholder/port.size = base_size * scale
	$worldholder.rect_scale = Vector2(1, 1) / scale


func set_title(what: String):
	window_title = what

func apply_world(this_world: PackedScene):
	world = this_world.instance()
	$worldholder/port.add_child(world)
	
	world.connect("tree_exiting", self, "_on_world_slain")

func egress():
	$animator.play("depart")


func _on_world_slain():
	emit_signal("world_slain")
	egress()

