extends RigidBody2D


var hat: Hat = null setget set_hat


func activate():
	if PlayerStats.don_hat(hat):
		queue_free()

func leap():
	var speed = rand_range(100, 300)
	var dir = rand_range(-1, 1)
	apply_central_impulse( Vector2(0, -speed).rotated(dir) )

func set_hat(what: Hat):
	hat = what
	
	$sprite.texture = what.sprite
	$sprite.hframes = what.small_frames


func _on_entity_detector_activated() -> void:
	activate()
