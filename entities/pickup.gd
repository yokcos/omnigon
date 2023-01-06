extends RigidBody2D


var highlight_distance = 80
var can_be_collected: bool = false
var thru_walls: bool = true

var tex_fx = preload("res://fx/hat_collect.png")
var current_tooltip: Node2D = null
var is_closest: bool = false
var active: bool = true

const obj_hitbox = preload("res://pieces/hitbox_octagon.tscn")
const obj_detector = preload("res://pieces/entity_detector.tscn")
var obj_tooltip: PackedScene


func _ready() -> void:
	var new_hitbox = obj_hitbox.instance()
	add_child(new_hitbox)
	
	var new_detector = obj_detector.instance()
	new_detector.connect("activated", self, "_on_entity_detector_activated")
	add_child(new_detector)
	
	var new_cs = CollisionShape2D.new()
	new_detector.add_child(new_cs)
	
	var new_shape = CircleShape2D.new()
	new_shape.radius = 16
	
	new_cs.shape = new_shape
	
	add_to_group("tooltipables")

func _process(delta: float) -> void:
	is_closest = Game.closest_tooltipable == self
	if is_closest and !is_instance_valid(current_tooltip):
		deploy_tooltip()
	if !is_closest and is_instance_valid(current_tooltip):
		destroy_tooltip()

func _unhandled_input(event: InputEvent) -> void:
	if is_closest and event.is_action_pressed("interact"):
		activate()


func deploy_tooltip():
	destroy_tooltip()
	
	var new_tooltip = obj_tooltip.instance()
	new_tooltip.connect("tree_exiting", self, "_on_tooltip_slain")
	Game.deploy_instance(new_tooltip, global_position + Vector2(0, -48))
	
	current_tooltip = new_tooltip
	return new_tooltip

func destroy_tooltip():
	if is_instance_valid(current_tooltip):
		current_tooltip.queue_free()

func activate():
	Game.deploy_fx(tex_fx, global_position, 8)
	destroy_tooltip()
	queue_free()


func _on_entity_detector_activated() -> void:
	pass

func _on_tooltip_slain():
	current_tooltip = null
