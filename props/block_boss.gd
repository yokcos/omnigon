extends StaticBody2D


func _ready() -> void:
	Game.connect("boss_changed", self, "_on_boss_changed")
	
	deactivate()
	$sprite.frame = 0


func activate():
	$hitbox.disabled = false
	$sprite.show()

func deactivate():
	$hitbox.disabled = true
	$sprite.hide()


func _on_boss_changed(what: Being):
	if what:
		activate()
	else:
		deactivate()
