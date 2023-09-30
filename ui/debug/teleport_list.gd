extends Control


func _ready() -> void:
	for i in $list.get_children():
		if i is Button:
			i.connect("pressed", self, "_on_button_pressed")

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("test"):
		visible = !visible
		if visible:
			$list/start.grab_focus()
			for i in $list.get_children():
				if i is Button:
					i.update_visibility()


func _on_button_pressed():
	hide()
