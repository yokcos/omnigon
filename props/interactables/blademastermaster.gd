extends Node2D


const foe_blademaster = preload("res://entities/enemies/data/blademaster.tres")


func _ready() -> void:
	select_interactable()


func select_interactable():
	deactivate_all_interactables()
	
	var index: int = 0
	if PlayerStats.upgrades.has("rapiers"):
		index += 1
	if PlayerStats.get_kills(foe_blademaster) > 0:
		index += 2
	$interactables.get_child(index).active = true
	

func deactivate_all_interactables():
	for i in $interactables.get_children():
		i.active = false
