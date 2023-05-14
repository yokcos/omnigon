extends Control


func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	Game.pause()


func _on_quit():
	var player = Game.get_player()
	if player:
		player.set_state("unsitting")
	
	Game.unpause()
	PlayerStats.fill_hp()
	queue_free()
