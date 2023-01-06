extends CPUParticles2D


func _ready() -> void:
	emitting = true
	one_shot = true
	
	var timer = get_tree().create_timer(lifetime)
	timer.connect("timeout", self, "expire")


func expire() -> void:
	emitting = false
	queue_free()
