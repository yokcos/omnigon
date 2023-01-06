extends Enemy


export (float) var force = 550

var obj_adept = load("res://entities/enemies/adept.tscn")


func _process(delta: float) -> void:
	if $tip.overlapping_entities.size() > 0:
		activate()


func send_them():
	for thing in $tip.overlapping_entities:
		thing.velocity.y = velocity.y - force
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_spring, global_position)

func activate():
	$fsm/idle.activate()

func get_shifted():
	Game.replace_instance(self, obj_adept.instance())
