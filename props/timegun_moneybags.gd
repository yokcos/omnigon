extends "res://props/animator_haver.gd"


var current_popup = null

const obj_jail = preload("res://animations/jail/jail.tscn")


func focus_here():
	Game.focus_cam( $focus.global_position, .8 )
	Game.zoom_cam(.6)

func unfocus():
	Game.unfocus_cam()
	Game.zoom_cam()

func deploy_animation():
	var new_popup = Game.summon_popup_world(obj_jail, "Witness the shootening")
	new_popup.anchor = self
	new_popup.max_distance = 10000
	new_popup.connect("tree_exiting", self, "_on_popup_slain")
	current_popup = new_popup
	
	var player = Game.get_player()
	if is_instance_valid(player):
		player.long_stun()


func _on_popup_slain():
	var player = Game.get_player()
	if is_instance_valid(player):
		player.set_state("normal")
