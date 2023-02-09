extends Node2D


var activated: bool = false
var apparitions = []



func activate():
	if !activated:
		activated = true
		
		apparitions = []
		for i in get_children():
			if i.filename == "res://entities/enemies/apparition.tscn":
				apparitions.append(i)
		apparitions.shuffle()
		
		$timer.start()

func activate_one_apparition():
	if apparitions.size() > 0:
		var this_apparition = apparitions.pop_front()
		this_apparition.activate()


func _on_timer_timeout() -> void:
	if activated:
		activate_one_apparition()
