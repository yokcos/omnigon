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
		
	rotation += rotation_speed * delta
	calculate_position()


func calculate_position():
	var x0 = start_position.x
	var x1 = end_position.x
	
	var x: float = lerp(x0, x1, time)
	var y: float = calculate_y(x)
	
	global_position = Vector2(x, y)

func calculate_y(x: float):
	var x0 = start_position.x
	var x1 = end_position.x
	var x2 = (start_position.x + end_position.x) / 2
	var y0 = start_position.y
	var y1 = end_position.y
	var y2 = min(start_position.y, end_position.y) - 48
	
	# Preventing division by zero errors
	if x0 == x1:
		x0 += 1
	
	# ok listen, all this junk here generates the correct equation for the relevant parabola
	var a_numerator  : float = y2-y0 + (y0-y1)*(x0-x2) / (x0-x1)
	var a_denominator: float = x2*x2 - x0*x0 + (x1*x1 - x0*x0)*(x2-x0) / (x0-x1)
	if a_denominator == 0: a_denominator = .01
	
	var a: float = a_numerator / a_denominator
	var b: float = ( y0-y1 + a*(x1*x1 - x0*x0) )/(x0-x1)
	var c: float = y0 - a*x0*x0 - b*x0
	
	var y: float = a*x*x + b*x + c
	return y
