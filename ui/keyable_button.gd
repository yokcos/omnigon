extends Button


export (String) var base_text = ""
export (String) var action = "jump"


func _ready() -> void:
	var template = "%s ({%s})" % [base_text, action]
	text = Game.replace_input_string(template)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(action) and is_visible_in_tree():
		emit_signal("button_down")
		emit_signal("pressed")
