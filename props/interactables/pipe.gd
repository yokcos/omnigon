extends Interactable


var spawn_position: Vector2 = Vector2()
var open: bool = false
var mode: int = 0


func _ready() -> void:
	spawn_position = global_position
	
	description = "Pipe"
	verb = "Unseal"


func get_saved():
	return {
		"mode": mode
	}

func get_loaded(what: Dictionary):
	if what.has("mode"):
		mode = what["mode"]
	
	update_sprite()

func activate():
	.activate()
	
	open_pipe()

func open_pipe():
	if active:
		open = true
		active = false
		
		GlobalSound.play_random_sfx(GlobalSound.sfx_fart)
		
		$body/sprite.frame = 1
		$body/sprite_not.frame = 1
		return true
	
	return false

func update_sprite():
	$body/sprite.visible = mode == 0
	$body/sprite_not.visible = mode == 1


func _on_shift_detector_shifted() -> void:
	mode = 1 - mode
	update_sprite()
