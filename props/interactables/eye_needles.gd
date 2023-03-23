extends Interactable


var animation = preload("res://animations/eye_needles/eye_needles.tscn")
var current_popup = null


func activate():
	.activate()
	
	current_popup = Game.summon_popup_world(animation, "Witness the eye needles")
	if is_instance_valid(current_popup):
		current_popup.connect("world_slain", self, "_on_popup_slain")
	
	#$animator.play("stab")
	
	var player = Game.get_player()
	if is_instance_valid(player):
		#player.set_stun_duration(1)
		#player.force_move(global_position + Vector2(-15, 0))
		player.long_stun()


func remove_eyes():
	PlayerStats.eyes = PlayerStats.EYES_NONE

func _on_popup_slain():
	remove_eyes()
	
	var player = Game.get_player()
	if is_instance_valid(player):
		player.set_state("normal")
