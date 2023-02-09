extends Enemy


var obj_apparition: PackedScene = load("res://entities/enemies/apparition.tscn")
var grouped_pestilents: Array = []


func _ready() -> void:
	saving_enabled = false
	friction = 0

func _process(delta: float) -> void:
	var room_size = Rooms.get_room_size(Rooms.current_room) * Rooms.room_size
	
	if global_position.x < 0:
		velocity.x = max(velocity.x, speed)
	if global_position.y < 0:
		velocity.y = max(velocity.y, speed)
	if global_position.x > room_size.x:
		velocity.x = min(velocity.x,-speed)
	if global_position.y > room_size.y:
		velocity.x = min(velocity.y,-speed)


func get_shifted():
	var new_apparition = obj_apparition.instance()
	Game.deploy_instance(new_apparition, global_position)
	new_apparition.immediate_activation = true
	
	for i in grouped_pestilents:
		i.queue_free()

func collide_against(hit: KinematicCollision2D):
	.collide_against(hit)
	
	velocity += hit.normal * speed
