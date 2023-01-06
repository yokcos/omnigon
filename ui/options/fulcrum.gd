class_name MenuFulcrum
extends Control


export(NodePath) var focus_target = ""
export (bool) var selectable = true

var target_rotation: float = 0
var target_size: float = 1
var position: int = 0

signal selected


func _ready() -> void:
	connect("focus_entered", self, "_on_focus_entered")
	if selectable:
		get_node(focus_target).connect("focus_entered", self, "_on_child_grabbed")

func _process(delta: float) -> void:
	rect_rotation = rad2deg(lerp_angle(deg2rad(rect_rotation), deg2rad(target_rotation), delta*5))
	var new_size: float = lerp( rect_scale.x, target_size, delta*5 )
	rect_scale = Vector2(new_size, new_size)


func connect_neighbours(prev: Control, next: Control):
	var main_node: Control = get_node(focus_target)
	var prev_path = main_node.get_path_to(prev)
	var next_path = main_node.get_path_to(next)
	
	main_node.focus_neighbour_top = prev_path
	main_node.focus_previous = prev_path
	main_node.focus_neighbour_bottom = next_path
	main_node.focus_next = next_path


func _on_focus_entered():
	get_node(focus_target).grab_focus()

func _on_child_grabbed():
	emit_signal("selected", position)
