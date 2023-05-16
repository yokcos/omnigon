extends ViewportContainer


signal ended


func _on_ended(score):
	emit_signal("ended", score)
	queue_free()
