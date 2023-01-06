extends Label


export (String, MULTILINE) var base_text = ""


func _ready() -> void:
	apply()


func apply():
	text = Game.replace_input_string(base_text)


