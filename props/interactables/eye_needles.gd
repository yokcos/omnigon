extends Interactable


func activate():
	.activate()
	$animator.play("stab")
	
	var player = Game.get_player()
	if player:
		player.force_move(global_position + Vector2(-15, 0))


func remove_eyes():
	PlayerStats.eyes = PlayerStats.EYES_NONE
