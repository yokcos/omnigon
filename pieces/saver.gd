extends Node


export (bool) var auto_activate = true


func _ready() -> void:
	if auto_activate:
		$autostarter.start()


func activate():
	Game.save_game()
