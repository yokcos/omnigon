extends StaticBody2D


export (Vector2) var target = Vector2()

var open: bool = false


func begin_teleport():
	var player = Game.get_player()
	if is_instance_valid(player):
		player.set_state("teleport")
	$sfx.play()
	$teleport_timer.start()
	$text/animator.play("hum")

func teleport():
	var player = Game.get_player()
	if is_instance_valid(player):
		player.set_state("normal")
	
	Events.emit_signal("teleported")
	Rooms.player_enter_room(target)

func enable_hitboxes():
	$hitbox2.disabled = false
	$hitbox3.disabled = false
	$hitbox4.disabled = false

func _on_interactable_activated() -> void:
	open = true
	
	enable_hitboxes()
	$interactable.active = false
	$entity_detector/hitbox.disabled = false
	$animator.play("open")
	
	GlobalSound.play_random_sfx(GlobalSound.sfx_teleporter_buttons)

func _on_entity_detector_activated() -> void:
	$animator.play("close")
	
	var player = Game.get_player()
	if is_instance_valid(player):
		player.long_stun()
		player.global_position = $centre.global_position
		player.velocity = Vector2()


func _on_teleport_timer_timeout() -> void:
	$animator.play("zap")
	GlobalSound.play_random_sfx(GlobalSound.sfx_teleporter_activate)
