extends AnimationPlayer


func _process(delta: float) -> void:
	if is_playing():
		var pos = get_node("../scene/cloun0").position.round()
		var time = current_animation_position
		var namn = current_animation
		
		var s_time = str(time).pad_decimals(6)
		#print( "%s | %s ==> %s" % [namn, s_time, pos] )


func play(what: String = "", custom_blend: float = -1, custom_speed: float = 1, from_end: bool = false):
	.play(what, custom_blend, custom_speed, from_end)
	#print("Playing %s" % what)
