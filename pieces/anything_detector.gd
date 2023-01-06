extends Area2D


export (Array, String) var target_groups = [""]
export (bool) var active = true setget set_active

var overlapping_entities = []


signal activated
signal deactivated
signal updated


func _ready() -> void:
	connect("area_entered", self, "_on_thing_entered")
	connect("body_entered", self, "_on_thing_entered")
	
	connect("area_exited", self, "_on_thing_exited")
	connect("body_exited", self, "_on_thing_exited")


func set_active(what: bool):
	active = what
	if !active:
		overlapping_entities = []

func check():
	var count = count_entities()
	
	if count == 0:
		emit_signal("deactivated")
	else:
		for i in range(count):
			emit_signal("activated")

func count_entities():
	return overlapping_entities.size()

func is_valid_target(what: CollisionObject2D) -> bool:
	if what:
		for group in target_groups:
			if what.is_in_group(group):
				return true
	
	return false


func _on_thing_entered(body: CollisionObject2D) -> void:
	if !overlapping_entities.has(body) and is_valid_target(body) and active:
		if count_entities() <= 0:
			emit_signal("activated")
		overlapping_entities.append(body)
		emit_signal("updated", overlapping_entities)

func _on_thing_exited(body: CollisionObject2D) -> void:
	if overlapping_entities.has(body) and active:
		if count_entities() <= 1:
			emit_signal("deactivated")
		overlapping_entities.erase(body)
		emit_signal("updated", overlapping_entities)
