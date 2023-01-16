extends Area2D


var walls: Array = []
var prev_wall: bool = false
var has_wall: bool = false


signal activated
signal deactivated
signal updated


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	do_signals()


func check_all():
	walls = get_overlapping_bodies()
	
	update_status()

func update_status():
	if walls.size() > 0:
		if !has_wall:
			has_wall = true
	else:
		if has_wall:
			has_wall = false
	
	do_signals_manual()
	emit_signal("updated", has_wall)

func do_signals_manual():
	if has_wall:
		activate()
	else:
		deactivate()
	
	prev_wall = has_wall

func do_signals():
	if has_wall != prev_wall:
		do_signals_manual()


func activate():
	emit_signal("activated")

func deactivate():
	emit_signal("deactivated")

func reset():
	has_wall = false
	emit_signal("updated", has_wall)


func _on_wall_detector_body_entered(body: Node) -> void:
	if !walls.has(body):
		walls.append(body)
		update_status()

func _on_wall_detector_body_exited(body: Node) -> void:
	if walls.has(body):
		walls.erase(body)
		update_status()
