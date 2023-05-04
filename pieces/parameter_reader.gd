extends Node


export (String) var parameter = ""
var active: bool = false


signal activated
signal deactivated


func _ready() -> void:
	update_status()
	call_deferred("emit_relevant_signal")

func _process(delta: float) -> void:
	update_status()


func update_status():
	var father = get_parent()
	if parameter in father:
		var value = father[parameter]
		if value != active:
			active = value
			emit_relevant_signal()

func emit_relevant_signal():
	if active: emit_signal("activated")
	else: emit_signal("deactivated")
