extends Interactable


export (String, MULTILINE) var error_text = ""

const obj_wall = preload("res://ui/wall.tscn")


func activate():
	.activate()
	
	var new_popup = Game.summon_popup_world(obj_wall)
	if new_popup:
		new_popup.anchor = self


func _on_shift() -> void:
	Game.summon_popup("ERROR", error_text, "How foolish of me", self)
