extends Node2D


var current_innard: Node2D = null
var inside: bool = false
var to_exclusivify: bool = false

const obj_innard = preload("res://props/megalift_innard.tscn")

const descriptions = ["Lift", "Exitway"]
const verbs = ["Ingress", "Egress"]


func _ready() -> void:
	if !WorldSaver.load_data("has_megalift"):
		hide()
		queue_free()
	else:
		show()
	
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
	update_interactable()

func ingress():
	var new_innard = obj_innard.instance()
	add_child(new_innard)
	new_innard.arrive()
	current_innard = new_innard
	inside = true
	update_interactable()

func egress():
	if is_instance_valid(current_innard):
		current_innard.egress()
		current_innard = null
	inside = false
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

func cull_other_megalifts():
	for i in get_tree().get_nodes_in_group("megalifts"):
		if i != self:
			i.hide()
			i.queue_free()


func _on_interactable_activated() -> void:
	if inside:
		egress()
	else:
		ingress()
