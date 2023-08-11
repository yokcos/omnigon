extends Node


func _ready() -> void:
	Events.connect("megalift_created", get_parent(), "activate")


