extends KinematicBody2D


export (NodePath) var target_tiles = ""
export (float) var longitude_change = 0
export (float) var speed = 200

var target_position: Vector2 = Vector2()
var final_position: Vector2 = Vector2()
var moving = false


func _ready() -> void:
	target_position = global_position
	final_position = target_position
	final_position.x += longitude_change
	
	var tilemap: TileMap = get_node(target_tiles)
	$wall_changer0.tiles = tilemap
	$wall_changer1.tiles = tilemap

func _process(delta: float) -> void:
	if moving:
		if longitude_change < 0:
			$wall_changer0.activate()
		if longitude_change > 0:
			$wall_changer1.activate()
		
		move(delta)
		var step = delta*speed
		if target_position.distance_squared_to(final_position) <= step*step:
			target_position = final_position
			deactivate()

func _physics_process(delta: float) -> void:
	global_position = global_position.linear_interpolate(target_position, delta*10)


func move(delta: float):
	var relative = final_position - target_position
	var dir = relative.normalized()
	target_position += dir * speed*delta

func activate():
	moving = true
	$animator.play("activate")

func deactivate():
	moving = false
	$animator.play("RESET")


func _on_button_activated() -> void:
	if !moving:
		activate()
