extends Node
class_name State


export (String) var animation = ""
export (String) var auto_proceed = ""

var father: Node = null

var active: bool = false
var age: float = 0


signal entered
signal exited


func _process(delta: float) -> void:
	if active:
		age += delta
		_step(delta)

func _unhandled_input(event: InputEvent) -> void:
	if active:
		if !Game.popup_exists():
			_handle_input(event)


func _enter() -> void:
	active = true
	emit_signal("entered")
	age = 0

func _exit() -> void:
	active = false
	emit_signal("exited")
	age = 0

func _step(delta: float) -> void:
	pass

func _handle_input(event: InputEvent) -> void:
	pass

func set_state(what: String) -> void:
	if active:
		get_parent().set_state_string(what)

func get_animator() -> AnimationPlayer:
	return get_parent().animator

func is_time_now(what_time: float, delta: float) -> bool:
	return age >= what_time and age < what_time + delta


