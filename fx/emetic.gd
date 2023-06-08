extends RigidBody2D


signal acided

func _ready() -> void:
	angular_velocity = 7


func get_acided():
	emit_signal("acided")
	
	queue_free()
