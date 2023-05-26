extends Node2D


func activate():
	if !$animator.is_playing():
		$animator.play("shoot")
		GlobalSound.play_random_sfx_2d( GlobalSound.sfx_blast_spacemine, global_position )
