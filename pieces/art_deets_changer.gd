extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		i.get_node("art").description = "Artistic Creation"
		i.get_node("art").verb = "Behold"
