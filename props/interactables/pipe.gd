extends Interactable


var spawn_position: Vector2 = Vector2()
var open: bool = false


func _ready() -> void:
	spawn_position = global_position
	
	description = "Pipe"
	verb = "Unseal"


func activate():
	.activate()
	
	open()

func open():
	if active:
		open = true
		active = false
		
		GlobalSound.play_random_sfx(GlobalSound.sfx_fart)
		
		$body/sprite.frame = 1
		return true
	
	return false


