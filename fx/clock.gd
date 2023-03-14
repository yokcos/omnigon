extends Node2D


var age: float = 0
var tick_interval: float = 0.25


func _ready() -> void:
	$hand0.rotation = randf() * 2*PI
	$hand1.rotation = randf() * 2*PI
	$outer.rotation = randf() * 2*PI
	$inner.rotation = randf() * 2*PI

func _process(delta: float) -> void:
	$hand0.rotation_degrees += delta * 360
	$hand1.rotation_degrees += delta * 30
	$outer.rotation_degrees -= delta * 10
	$inner.rotation_degrees += delta * 10
	
	age += delta
	if age > tick_interval:
		GlobalSound.play_random_sfx_2d(GlobalSound.sfx_tick, global_position)
		age -= tick_interval
