class_name StatusEffect
extends Node


var father: Node = null
var duration: float = 1


func _ready() -> void:
	father = get_parent()
	_apply()

func _process(delta: float) -> void:
	duration -= delta
	if duration <= 0:
		_expire()


func _apply():
	pass

func _expire():
	queue_free()
