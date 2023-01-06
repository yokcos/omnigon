extends CPUParticles2D


signal stopped


func stop_emitting():
	emitting = false
	$death_timer.start(lifetime)
	emit_signal("stopped")

func die() -> void:
	queue_free()
