extends Node2D


export (Vector2) var target = Vector2()
export (Vector2) var vomit_velocity = Vector2()

var active: bool = false
var current_sfx: SFX = null


func _process(delta: float) -> void:
	if active and randf() * 30 < 1:
		Game.shake_cam(rand_range(-6, 6), PI/2)


func get_wronged():
	activate()
	deploy_wrongtext()

func activate():
	active = true
	current_sfx = GlobalSound.play_random_sfx(GlobalSound.sfx_regurgitation)
	
	$part_regurgitation.emitting = true
	$short_timer.start()
	$timer.start()

func deploy_wrongtext():
	var angle: float = 10
	
	var xdir = Vector2(48, 0).rotated(deg2rad(angle))
	var ydir = Vector2(0, 16).rotated(deg2rad(angle))
	
	var colours = [Color("5b3138"), Color("328464")]
	
	for i in range(-16, 16):
		for j in range(-16, 16):
			var new_label = Label.new()
			new_label.rect_rotation = angle
			new_label.text = "WRONG"
			new_label.add_color_override("font_color", colours[posmod(i+j, 2)])
			
			$wrongtext.add_child(new_label)
			new_label.rect_position += i * xdir
			new_label.rect_position += j * ydir

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
	GlobalSound.play_random_sfx(GlobalSound.sfx_bleh)
	Events.delayed_emit("vendor_vomited", .1)


func _on_short_timer_timeout() -> void:
	halt()

func _on_timer_timeout() -> void:
	vomit()
