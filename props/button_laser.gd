extends Node2D


var armed: bool = false
var obj_button_floor = load("res://props/button_floor.tscn")

signal activated


func _ready() -> void:
	call_deferred("resize_laser")

func _process(delta: float) -> void:
	if armed and $raycast.is_colliding():
		emit_signal("activated")
		armed = false
		$line.hide()
		$reset_timer.start()



func resize_laser():
	$raycast.force_raycast_update()
	
	var relative: Vector2 = $raycast.get_collision_point() - $raycast.global_position
	var distance: float = relative.length()
	$line.points[1].y = -distance
	$line.show()
	$raycast.cast_to.y = -distance + 1
	armed = true
	
	$raycast.force_raycast_update()


func _on_reset_timer_timeout() -> void:
	$line.show()
	armed = true

func _on_shift() -> void:
	var new_button = obj_button_floor.instance()
	for i in get_signal_connection_list( "activated" ):
		new_button.connect("activated", i["target"], i["method"])
	Game.replace_instance(self, new_button)
