extends Node


export (String) var victim_name = ""
export (bool) var approximate_name = true


func delayed_activate():
	call_deferred("activate")

func activate():
	var all = Game.get_all_descendents( get_parent() )
	var valid_target: bool
	
	
	for i in all:
		valid_target = i.name == victim_name
		valid_target = valid_target or ( approximate_name and i.name.find(victim_name) >= 0 )
		
		if valid_target:
			i.queue_free()
