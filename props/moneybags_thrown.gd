extends Node2D


var start_position: Vector2
var end_position: Vector2
var time: float = 0
var duration: float = 8
var rotation_speed = 8


signal finished


func _ready() -> void:
	var points: PoolVector2Array = PoolVector2Array()
	var minimum = min(start_position.x, end_position.x)
	var maximum = max(start_position.x, end_position.x)
	for x in range(0, 1500, 10):
		var y: float = calculate_y(x)
		points.append( Vector2(x, y) )
	$test.points = points

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
	
	$test.global_position = Vector2()
	$test.global_rotation = 0


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
	
	var a: float = ( y2-y0 + (y0-y1)*(x0-x2) / (x0-x1) )/\
	( x2*x2 - x0*x0 + (x1*x1 - x0*x0)*(x2-x0) / (x0-x1) )
	var b: float = ( y0-y1 + a*(x1*x1 - x0*x0) )/(x0-x1)
	var c: float = y0 - a*x0*x0 - b*x0
	
	if time >= 1:
		print("y = %sx^2 + %sx + %s" % [a, b, c])
	
	var y: float = a*x*x + b*x + c
	return y
