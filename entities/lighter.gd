extends "res://entities/pickup.gd"


export (int) var type = 0
export (String) var lighter_name = ""
export (String) var lighter_desc = ""

var source_position: Vector2 = Vector2()


func _ready() -> void:
	obj_tooltip = preload("res://ui/lighter_announcement.tscn")


func deploy_tooltip():
	var new_tooltip = .deploy_tooltip()
	
	new_tooltip.set_stuff(lighter_name, lighter_desc)

func activate() -> void:
	.activate()
	
	PlayerStats.gain_lighter(type)
	WorldSaver.save_data( source_position, true )
	
	queue_free()
