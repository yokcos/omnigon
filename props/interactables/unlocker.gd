extends Node2D


export (PoolVector2Array) var rooms = PoolVector2Array()
export (PoolVector2Array) var loactions = PoolVector2Array()

var spawn_position

const obj_fx = preload("res://fx/unlocker_break.tscn")


func _ready() -> void:
	spawn_position = global_position
	if WorldSaver.load_data(spawn_position):
		hide()
		queue_free()


func get_saved():
	return {}

func get_loaded(_what: Dictionary):
	pass


func _on_interactable_activated() -> void:
	for i in range(rooms.size()):
		WorldSaver.save_room_data(loactions[i], true, rooms[i])
	
	var new_fx = obj_fx.instance()
	Game.deploy_instance(new_fx, global_position)
	GlobalSound.play_random_sfx_2d(GlobalSound.sfx_vertex_grab, global_position)
	
	WorldSaver.save_data(spawn_position, true)
	queue_free()
