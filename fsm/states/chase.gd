extends State


var target: Node2D = null
var wall_detector: Area2D = null


func _step(delta: float):
	._step(delta)
	
	if is_instance_valid(target):
		var tpos: Vector2 = target.global_position
		var fpos: Vector2 = father.global_position
		
		if tpos.x < fpos.x:
			father.accelerate(-1, delta)
		if tpos.x > fpos.x:
			father.accelerate( 1, delta)
		
		if tpos.y < fpos.y and abs(tpos.x - fpos.x) < abs(tpos.y - fpos.y) and father.is_grounded():
			father.jump()
	
	if is_instance_valid(wall_detector):
		if wall_detector.has_wall and father.is_grounded():
			father.jump()
