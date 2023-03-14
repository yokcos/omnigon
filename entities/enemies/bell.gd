extends Enemy


var duration: float = 4
var phase: float = 0
var exploded: bool = false


var obj_child = load("res://entities/enemies/grandchilddrook.tscn")
var fx_zapfront = preload("res://fx/zapfront.tscn")


func _process(delta: float) -> void:
	var extra = (4 - duration) / 4
	extra = clamp(extra, 0, 1)
	phase += extra
	phase = fposmod(phase, 0.2)
	if phase > 0.18:
		$flippable/sprite.frame = 1
	else:
		$flippable/sprite.frame = 0
	
	duration -= delta
	if duration <= 0 and !exploded:
		explode()


func explode():
	exploded = true
	$hurtbox.pulse()
	$flippable/sprite.hide()
	$timer.start()
	
	var new_sfx = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_bong, global_position)
	new_sfx.relative_volume = 0.5
	
	for i in range(8):
		var new_zapfront = fx_zapfront.instance()
		new_zapfront.rotation = randf() * 2*PI
		var size = rand_range(1, 1.2)
		new_zapfront.scale = Vector2(size, size)
		Game.deploy_instance(new_zapfront, global_position)

func get_shifted():
	var new_child = obj_child.instance()
	Game.replace_instance(self, new_child)


func _on_timer_timeout() -> void:
	queue_free()
