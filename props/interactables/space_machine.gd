extends Node2D


var is_open: bool = false
var armed: bool = false


func open():
	if !is_open:
		$animator.play("open")
		$collision/lid.disabled = true
		is_open = true

func close():
	if is_open:
		$animator.play("close")
		$collision/lid.disabled = false
		is_open = false

func begin_teleport():
	var player = Game.get_player()
	if is_instance_valid(player):
		player.set_state("teleport_fast")
	$teleport_timer.start()
	
	if is_instance_valid(Game.camera):
		Game.camera.extra_zoom_target = .5
	
	Game.achieve_cheeve("end")
	if PlayerStats.punches <= 0:
		Game.achieve_cheeve("no_hits")
	if PlayerStats.kills.keys().size() <= 0:
		Game.achieve_cheeve("no_kills")
	if PlayerStats.time <= 3600:
		Game.achieve_cheeve("speed")
	if !PlayerStats.sucker:
		Game.achieve_cheeve("threebuttons")
	
	Game.save_game(Vector2(128, 32))


func _on_interactable_activated() -> void:
	call_deferred("open")
	$interactable.active = false

func _on_entity_detector0_activated() -> void:
	armed = false

func _on_entity_detector1_activated() -> void:
	armed = true

func _on_entity_detector2_activated() -> void:
	call_deferred("close")
	begin_teleport()

func _on_teleport_timer_timeout() -> void:
	GlobalSound.play_random_sfx(GlobalSound.sfx_blap)
	get_tree().change_scene("res://ui/ending.tscn")
