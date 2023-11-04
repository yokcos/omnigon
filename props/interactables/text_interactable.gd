class_name TextInteractable
extends Interactable


export (String) var title = "Sign of Text"
export (String, MULTILINE) var text = ""
export (String) var egress = "Alrighty"


func _ready() -> void:
	connect("activated", self, "summon_popup")


func summon_popup():
	if !is_instance_valid(Game.current_popup):
		Game.summon_popup(title, text, egress, self)


