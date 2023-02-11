class_name MultiTextInteractable
extends Interactable


export (PoolStringArray) var titles = ["Sign of Text"]
export (Array, String, MULTILINE) var texts = [""]
export (PoolStringArray) var egresses = ["Alrighty"]


func _ready() -> void:
	connect("activated", self, "summon_popup")


func summon_popup():
	if titles.size() == texts.size() and texts.size() == egresses.size():
		for i in range(titles.size()):
			Game.summon_popup(titles[i], texts[i], egresses[i], self)


