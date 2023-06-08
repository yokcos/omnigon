extends Node2D


export (NodePath) var quizzenator_path = ""
onready var quizzenator = get_node(quizzenator_path)

var active: bool = false

const obj_spotlight = preload("res://fx/spotlight.tscn")


func activate():
	if !active:
		active = true
		
		quizzenator.activate()
		quizzenator.show()
		
		var new_spotlight
		new_spotlight = obj_spotlight.instance()
		new_spotlight.target = quizzenator
		new_spotlight.rotation = PI*3/4
		Game.deploy_instance(new_spotlight, quizzenator.global_position)
		new_spotlight = obj_spotlight.instance()
		new_spotlight.target = Game.get_player()
		new_spotlight.rotation = PI*1/4
		Game.deploy_instance(new_spotlight, Game.get_player().global_position)
		
		for i in get_children():
			if i is Path2D:
				i.activate()
		
		GlobalSound.play_temp_music("interioramusement")
