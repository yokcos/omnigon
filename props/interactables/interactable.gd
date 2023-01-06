class_name Interactable
extends Node2D


export (float) var highlight_distance = 48
export (String) var description = ""
export (String) var verb = "Obtain"
export (bool) var thru_walls = false

var current_tooltip: Node2D = null
var is_closest: bool = false
var active: bool = true
var cast: RayCast2D = null

const obj_tooltip = preload("res://ui/interactable_tooltip.tscn")

signal activated


func _ready() -> void:
	add_to_group("interactables")
	add_to_group("tooltipables")
	
	cast = RayCast2D.new()
	cast.set_collision_mask_bit(0, false)
	cast.set_collision_mask_bit(2, true)
	cast.add_exception(self)
	
	for i in get_children():
		if i is CollisionObject2D:
			cast.add_exception(i)
	
	add_child(cast)

func _process(delta: float) -> void:
	is_closest = Game.closest_tooltipable == self
	if is_closest and !current_tooltip:
		deploy_tooltip()
	if !is_closest and current_tooltip:
		destroy_tooltip()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_closest:
		activate()

func _exit_tree() -> void:
	if current_tooltip:
		current_tooltip.queue_free()
		current_tooltip = null


func check_line_of_sight(to: Vector2) -> bool:
	var relative: Vector2 = to - global_position
	var r_length: float = relative.length()
	var edge_cull: float = 4
	
	if r_length <= edge_cull*2:
		return true
	else:
		var unit: Vector2 = relative.normalized()
		relative -= unit * edge_cull*2
		cast.position = unit * edge_cull
	
	cast.cast_to = (to - global_position).rotated(-global_rotation)
	cast.enabled = true
	cast.force_raycast_update()
	
	var result = cast.is_colliding()
	
	cast.enabled = false
	
	return !result

func activate():
	emit_signal("activated")

func destroy_tooltip():
	if current_tooltip:
		#current_tooltip.disconnect("tree_exiting", self, "_on_tooltip_slain")
		current_tooltip.queue_free()
		#current_tooltip = null

func deploy_tooltip():
	destroy_tooltip()
	
	var new_tooltip = obj_tooltip.instance()
	new_tooltip.set_desc(description)
	new_tooltip.set_verb(verb)
	new_tooltip.connect("tree_exiting", self, "_on_tooltip_slain")
	Game.deploy_instance(new_tooltip, global_position + Vector2(0, -48))
	
	current_tooltip = new_tooltip

func get_closest_interactable() -> Node2D:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		var player_position = players[0].global_position
		
		var closest_distance = 1000000
		var closest_interactable = null
		
		for interactable in get_tree().get_nodes_in_group("interactables"):
			if interactable.active:
				var dist = interactable.global_position.distance_squared_to(player_position)
				if dist < closest_distance and dist <= interactable.highlight_distance * interactable.highlight_distance:
					if interactable.thru_walls or interactable.check_line_of_sight(player_position):
						closest_distance = dist
						closest_interactable = interactable
		
		return closest_interactable
	else:
		return null


func _on_tooltip_slain():
	current_tooltip = null
