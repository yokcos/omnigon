extends Node2D


var prev_edge: bool = true
var has_edge: bool = true

var walls: Array = []
var floors: Array = []


signal activated
signal deactivated
signal updated


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	do_signals()


func check_all():
	walls = $wall_detector.get_overlapping_bodies()
	floors = $edge_detector.get_overlapping_bodies()
	
	update_status()

func update_status():
	if walls.size() > 0 or floors.size() <= 0:
		if !has_edge:
			has_edge = true
	else:
		if has_edge:
			has_edge = false
	
	do_signals_manual()
	emit_signal("updated", has_edge)

func do_signals_manual():
	if has_edge:
		activate()
	else:
		deactivate()
	
	prev_edge = has_edge

func do_signals():
	if has_edge != prev_edge:
		do_signals_manual()


func activate():
	emit_signal("activated")

func deactivate():
	emit_signal("deactivated")

func reset():
	has_edge = false
	emit_signal("updated", has_edge)


func _on_wall_detector_body_entered(body: Node) -> void:
	if !walls.has(body):
		walls.append(body)
		update_status()

func _on_wall_detector_body_exited(body: Node) -> void:
	if walls.has(body):
		walls.erase(body)
		update_status()

func _on_edge_detector_body_entered(body: Node) -> void:
	if !floors.has(body):
		floors.append(body)
		update_status()

func _on_edge_detector_body_exited(body: Node) -> void:
	if floors.has(body):
		floors.erase(body)
		update_status()
