extends Sprite


var destination: Vector2 = Vector2()
var speed: float = 400
var velocity: Vector2 = Vector2()
var age: float = 0
var homing_time: float = 0.25
var die_distance_squared: float = 256
var phase: int = 0


func _ready() -> void:
	speed = rand_range(600, 1000)
	homing_time = rand_range(.1, .25)
	velocity = Vector2(speed, 0).rotated(randf() * 2*PI)
	var size: float = rand_range(.1, .5)
	scale = Vector2(size, size)
	rotation = rand_range(-.1, .1)

func _process(delta: float) -> void:
	age += delta
	position += velocity*delta
	
	match phase:
		0:
			if age > homing_time:
				phase = 1
				var relative = destination - global_position
				velocity = relative.normalized() * speed
		
		1:
			var dsquared = destination.distance_squared_to(global_position)
			if dsquared < die_distance_squared:
				queue_free()
