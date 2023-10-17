extends "res://ui/announcement.gd"


var cheeve: Cheeve = null setget set_cheeve
var time_left: float = 6


func _ready() -> void:
	$panel/bac/list/timer.max_value = time_left
	$panel/bac/list/timer.value = time_left

func _process(delta: float) -> void:
	time_left -= delta
	$panel/bac/list/timer.value = time_left
	if time_left <= 0:
		queue_free()


func set_cheeve(what: Cheeve):
	cheeve = what
	
	$panel/bac/list/titlebac/upperbar/title.text = what.name
	$panel/bac/list/titlebac/upperbar/icon.texture = what.achieved_icon
	$panel/bac/list/description.text = what.description
