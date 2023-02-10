extends "res://entities/pickup.gd"


var hat: Hat = null


signal collected


func _ready() -> void:
	obj_tooltip = preload("res://ui/hat_announcement.tscn")

func deploy_tooltip():
	var new_tooltip = .deploy_tooltip()
	
	new_tooltip.set_hat(hat)

func activate():
	.activate()
	emit_signal("collected")
	PlayerStats.gain_hat(hat)


func set_hat(what: Hat):
	hat = what
	
	$sprite.texture = what.sprite
	$sprite.hframes = what.small_frames

