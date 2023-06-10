extends Node2D


var obj_hungry = load("res://props/interactables/vendor_hungry.tscn")
const obj_vending_screen = preload("res://ui/vendor/vendor.tscn")
const obj_vomit_chunk = preload("res://fx/vomit_chunk.tscn")


func _ready() -> void:
	Events.connect("vendor_vomited", self, "vomit")


func vomit():
	for i in range(32):
		var new_chunk = obj_vomit_chunk.instance()
		new_chunk.velocity = Vector2(rand_range(100, 600), -49).rotated(rand_range(-.5, .5))
		Game.deploy_instance(new_chunk, global_position)


func _on_shift_detector_shifted() -> void:
	var new_hungry = obj_hungry.instance()
	Game.replace_instance(self, new_hungry)
