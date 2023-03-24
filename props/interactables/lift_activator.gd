extends Node2D


export (NodePath) var animation_thing

var active: bool = false


signal activated


func _ready() -> void:
	add_to_group("saveables")

func activate():
	active = true
	$interactable.active = false
	$animator.play("activate")
	WorldSaver.save_data("has_megalift", true)
	WorldSaver.save_global_data("megalift_active", true)
	Events.emit_signal("megalift_created")

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
