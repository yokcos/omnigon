extends Node


signal megalift_created
signal teleported
signal vendor_vomited

signal fishticuffs_score_gained


func delayed_emit(sig: String, delay: float):
	var new_timer = get_tree().create_timer(delay)
	new_timer.connect("timeout", self, "emit_signal", [sig])
