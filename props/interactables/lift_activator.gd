extends Node2D


var active: bool = false


func _ready() -> void:
	add_to_group("saveables")

func activate():
	active = true
	$interactable.active = false
	$animator.play("activate")

func get_saved():
	return {
		"active": active,
	}

func get_loaded(data: Dictionary):
	active = data["active"]
	if active:
		$animator.play("spin")


func _on_interactable_activated() -> void:
	var result = PlayerStats.consume_lighter(PlayerStats.LIGHTER_SOPHISTICATED)
	
	if result:
		activate()
	else:
		Game.summon_popup("Error", "This MECHANISM cannot be activated, for you do not have any SOPHISTICATED LIGHTERS!", "Ah piss", self)
