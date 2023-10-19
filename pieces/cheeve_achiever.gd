extends Node


export (String) var cheeve = ""
export (bool) var auto = false


func _ready() -> void:
	if auto: activate()

func activate():
	Game.achieve_cheeve(cheeve)
