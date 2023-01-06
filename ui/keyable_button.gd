extends Button


export (String) var action = "jump"


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(action):
		emit_signal("button_down")
		emit_signal("pressed")
