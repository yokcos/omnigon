extends Interactable


var spawn_position: Vector2 = Vector2()


func _ready() -> void:
	spawn_position = global_position
	
	description = "Pipe"
	verb = "Unseal"


func activate():
	.activate()
	
	open()

func open():
	if active:
		active = false
		
		GlobalSound.play_random_sfx(GlobalSound.sfx_fart)
		
		$body/sprite.frame = 1
		return true
	
	return false


