extends "res://ui/artwork/artwork.gd"


var current_rsoo: Node2D = null


func _ready() -> void:
	connect("tree_exiting", self, "_on_tree_exiting")
	
	resize_container()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if Game.rsoo_loaded:
			if current_rsoo:
				current_rsoo.egress()
			undeploy_game()
		else:
			load_game()


func resize_container():
	var target_size: Vector2 = $image_bac/image.rect_size
	var original_size: Vector2 = $game/port.size
	var size: Vector2 = target_size / original_size
	var min_size: float = min( size.x, size.y )
	$game.rect_scale = Vector2( min_size, min_size )

func load_game():
	if !Game.rsoo_loaded:
		Game.load_rsoo()
		
		call_deferred("deploy_game")
	$menu.hide()
	$image_bac/colourisation.color = Color(0, 0, 0, 1)

func deploy_game():
	var new_game: Node2D = load("res://rsoo/game.tscn").instance()
	new_game.connect("egressed", self, "_on_rsoo_egressed")
	new_game.nothing_path = "res://nothing.gd"
	$game/port.add_child(new_game)
	current_rsoo = new_game
	
	RSOOEvents.pause_mode = PAUSE_MODE_PROCESS
	RSOOGlobalSound.pause_mode = PAUSE_MODE_PROCESS
	RSOOLevels.pause_mode = PAUSE_MODE_PROCESS
	RSOO.pause_mode = PAUSE_MODE_PROCESS
	RSOOTransients.pause_mode = PAUSE_MODE_PROCESS
	RSOOUtility.pause_mode = PAUSE_MODE_PROCESS
	Physics2DServer.set_active(true)
	AudioServer.set_bus_volume_db(1, -1000)

func undeploy_game():
	if Game.rsoo_loaded:
		for i in $game/port.get_children():
			i.queue_free()
		
		Game.unload_rsoo()
	$menu.show()
	$image_bac/colourisation.color = Color("7f242234")
	Physics2DServer.set_active( !get_tree().paused )
	AudioServer.set_bus_volume_db(1, 0)
	
	$menu.call_deferred("seize_focus")


func _on_tree_exiting():
	undeploy_game()

func _on_rsoo_egressed():
	undeploy_game()

