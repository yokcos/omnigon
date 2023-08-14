extends CPUParticles2D


var pos: Vector2 = Vector2()


func _ready() -> void:
	get_parent().connect( "tree_exiting", self, "_on_parent_slain" )

func _process(delta: float) -> void:
	if is_inside_tree():
		pos = global_position


func _on_parent_slain():
	get_parent().remove_child(self)
	Game.deploy_instance_instant(self, pos)
	emitting = false
	$doom_timer.call_deferred("start", lifetime)

func _on_doom_timer_timeout() -> void:
	queue_free()
