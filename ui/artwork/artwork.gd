extends Control


func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	get_tree().paused = true


func _on_quit():
	var player = Game.get_player()
	if player:
		player.set_state("unsitting")
	
	get_tree().paused = false
	PlayerStats.fill_hp()
	queue_free()
