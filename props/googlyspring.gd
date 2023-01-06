extends Being


func _ready() -> void:
	Game.set_boss(self)


func get_shifted():
	var new_bouncer = load("res://entities/enemies/bouncer.tscn").instance()
	Game.replace_instance(self, new_bouncer)
