extends Node2D


func activate():
	pass


func _on_interactable_activated() -> void:
	activate()
	$interactable.active = false
