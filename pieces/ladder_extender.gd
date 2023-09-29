extends Node


var timer: Timer

export (bool) var active = false
export (int) var target_length = 1
export (float) var interval = .2


func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = interval
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")


func activate():
	active = true

func extend_one():
	if get_parent().actual_length != target_length:
		get_parent().actual_length += sign( target_length - get_parent().actual_length )

func extend_instant():
	get_parent().actual_length = target_length


func _on_timer_timeout():
	if active:
		extend_one()
