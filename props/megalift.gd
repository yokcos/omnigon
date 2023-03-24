extends Node2D


var current_innard: Node2D = null
var inside: bool = false
var to_exclusivify: bool = false

var obj_summoner = load("res://props/interactables/lift_summoner.tscn")
const obj_innard = preload("res://props/megalift_innard.tscn")

const descriptions = ["Lift", "Exitway"]
const verbs = ["Ingress", "Egress"]


func _ready() -> void:
	if WorldSaver.load_global_data("megalift_active"):
		var liftpos = WorldSaver.load_global_data("megalift_room")
		if liftpos == Rooms.current_room:
			show()
		else:
			deploy_summoner()
			hide()
			queue_free()
	else:
		hide()
		queue_free()
	
	update_interactable()

func _process(delta: float) -> void:
	if to_exclusivify and is_inside_tree():
		to_exclusivify = false
		cull_other_megalifts()


func instant_ingress():
	var new_innard = obj_innard.instance()
	add_child(new_innard)
	new_innard.instant_arrive()
	current_innard = new_innard
	inside = true
	limit_camera()
	update_interactable()

func ingress():
	var new_innard = obj_innard.instance()
	add_child(new_innard)
	new_innard.arrive()
	current_innard = new_innard
	inside = true
	limit_camera()
	update_interactable()

func egress():
	if is_instance_valid(current_innard):
		current_innard.egress()
		current_innard = null
	inside = false
	unlimit_camera()
	update_interactable()

func update_interactable():
	var index = 1 if inside else 0
	$interactable.description = descriptions[index]
	$interactable.verb = verbs[index]
	$interactable.destroy_tooltip()

func enable_interactable():
	$interactable.active = true

func disable_interactable():
	$interactable.active = false

func limit_camera():
	var cam = Game.camera
	if is_instance_valid(cam):
		if is_inside_tree():
			cam.limit_left  = global_position.x - 256
			cam.limit_right = global_position.x + 256
		else:
			cam.limit_left  = position.x - 256
			cam.limit_right = position.x + 256

func unlimit_camera():
	var cam = Game.camera
	if is_instance_valid(cam):
		var room_size = Rooms.get_room_size(Rooms.current_room)
		cam.limit_left  = 0
		cam.limit_right = room_size.x * Rooms.room_size.x

func cull_other_megalifts():
	for i in get_tree().get_nodes_in_group("megalifts"):
		if i != self:
			i.hide()
			i.queue_free()

func deploy_summoner():
	var new_summoner = obj_summoner.instance()
	Game.deploy_instance(new_summoner, global_position)


func _on_interactable_activated() -> void:
	if inside:
		egress()
	else:
		ingress()
