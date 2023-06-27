extends StaticBody2D


var active: bool = false
var appeared: bool = true


func _ready() -> void:
	Game.connect("boss_changed", self, "_on_boss_changed")
	
	deactivate()
	disappear()
	$sprite.frame = 0

func _process(delta: float) -> void:
	if active and !appeared:
		if $entity_detector.count_entities() <= 0:
			appear()
	if !active and appeared:
		disappear()


func appear():
	appeared = true
	$hitbox.disabled = false
	$sprite.show()

func disappear():
	appeared = false
	$hitbox.disabled = true
	$sprite.hide()

func activate():
	active = true

func deactivate():
	active = false


func _on_boss_changed(what: Being):
	if what:
		activate()
	else:
		deactivate()
