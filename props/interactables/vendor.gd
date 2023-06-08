extends Node2D


export (Array) var wares = []

var obj_hungry = load("res://props/interactables/vendor_hungry.tscn")
const obj_vending_screen = preload("res://ui/vendor/vendor.tscn")


func deploy_vending_screen():
	var new_vending_screen = obj_vending_screen.instance()
	new_vending_screen.wares = wares
	Game.deploy_ui_instance(new_vending_screen, Vector2())

func activate():
	$interactable.active = true


func _on_interactable_activated() -> void:
	deploy_vending_screen()

func _on_shift_detector_shifted() -> void:
	var new_hungry = obj_hungry.instance()
	Game.replace_instance(self, new_hungry)
