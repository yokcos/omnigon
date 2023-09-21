extends Panel


func _ready() -> void:
	var cracked: bool = false
	if WorldSaver.data.has(Rooms.current_room):
		var data = WorldSaver.data[Rooms.current_room]
		for dict in data:
			if dict is Dictionary and dict["type"] == "tile":
				cracked = true
				break
	
	if cracked:
		$wallhole.show()
		$text.text = "wow what a fragile wall"
	else:
		$wallhole.hide()
		$text.text = "wow what a fascinating wall"


