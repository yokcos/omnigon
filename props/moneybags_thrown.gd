extends Node2D


var start_position: Vector2
var end_position: Vector2
var time: float = 0
var duration: float = 2
var rotation_speed = 8


signal finished


func _process(delta: float) -> void:
	time += delta/duration
	if time >= 1:
		time = 1
		emit_signal("finished")
		queue_free()
		
		print(end_position)
		print(global_position.round())
	rotation += rotation_speed * delta
	calculate_position()


func calculate_position():
	var x0 = start_position.x
	var x1 = end_position.x
	var y0 = start_position.y
	var y1 = end_position.y
	
	var i: float = (y0 - y1) / (x0*x0 - x1*x1)
	var j: float = i * x0*x0 + y0
	var x: float = lerp(x0, x1, time)
	var y: float = -i * x*x + j
	
	if time >= 1:
		print(i, " - ", j)
	
	global_position = Vector2(x, y)
