extends Node2D


export (Vector2) var target = Vector2()
export (Vector2) var vomit_velocity = Vector2()

var active: bool = false
var current_sfx: SFX = null


func _process(delta: float) -> void:
	if active and randf() * 30 < 1:
		Game.shake_cam(rand_range(-6, 6), PI/2)


func activate():
	active = true
	current_sfx = GlobalSound.play_random_sfx(GlobalSound.sfx_regurgitation)
	
	$part_regurgitation.emitting = true
	$short_timer.start()
	$timer.start()

func deploy_wrongtext():
	var angle: float = 0.1
	
	for i in range(32):
		for j in range(32):
			var new_label = Label.new()
			

func halt():
	var player = Game.get_player()
	if is_instance_valid(player):
		player.long_stun()
	if is_instance_valid(current_sfx):
		current_sfx.queue_free()
	GlobalSound.play_random_sfx(GlobalSound.sfx_blap)
	$blackening.show()

func vomit():
	PlayerStats.velocity = vomit_velocity
	Rooms.player_enter_room(target)


func _on_short_timer_timeout() -> void:
	halt()

func _on_timer_timeout() -> void:
	vomit()
