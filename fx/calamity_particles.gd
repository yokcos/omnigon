extends CPUParticles2D


func _process(delta: float) -> void:
	if is_instance_valid(Game.camera):
		global_position.x = Game.camera.get_actual_position().x
