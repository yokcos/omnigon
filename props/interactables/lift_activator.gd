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
	WorldSaver.save_global_data("megalift_room", Rooms.current_room)
	WorldSaver.save_global_data("megalift_active", true)
	Events.emit_signal("megalift_created")
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_shift, global_position)

func get_saved():
	return {
		"active": active,
	}

func get_loaded(data: Dictionary):
	active = data["active"]
	if active:
		$animator.play("spin")
		$interactable.active = false


func _on_interactable_activated() -> void:
	var result = PlayerStats.consume_lighter(PlayerStats.LIGHTER_SOPHISTICATED)
	
	if result:
		activate()
	else:
		Game.summon_popup("Error", "This MECHANISM cannot be activated, for you do not have any SOPHISTICATED LIGHTERS!", "Ah piss", self)
