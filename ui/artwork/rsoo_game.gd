extends Control


func _ready() -> void:
	Game.load_rsoo()
	
	RSOOEvents.pause_mode = PAUSE_MODE_PROCESS
	RSOOGlobalSound.pause_mode = PAUSE_MODE_PROCESS
	RSOOLevels.pause_mode = PAUSE_MODE_PROCESS
	RSOO.pause_mode = PAUSE_MODE_PROCESS
	RSOOTransients.pause_mode = PAUSE_MODE_PROCESS
	RSOOUtility.pause_mode = PAUSE_MODE_PROCESS
	
	resize_gameholder()
	call_deferred("deploy_game")


func resize_gameholder():
	var size: Vector2 = rect_size / $gameholder/port.size
	var min_size: float = min( size.x, size.y )
	$gameholder.rect_scale = Vector2( min_size, min_size )

func deploy_game():
	var new_rsoo = load("res://rsoo/game.tscn").instance()
	new_rsoo.nothing_path = "res://nothing.gd"
	$gameholder/port.add_child(new_rsoo)



