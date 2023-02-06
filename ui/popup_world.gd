extends WindowDialog


var scale = 2
var base_size: Vector2 = Vector2(268, 220)

var anchor: Node2D = null
var max_distance: float = 96


func _ready() -> void:
	$worldholder/port.size = base_size * scale
	$worldholder.rect_scale = Vector2(1, 1) / scale

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		if anchor:
			var dist = anchor.global_position.distance_squared_to( players[0].global_position )
			if dist > max_distance*max_distance:
				egress()
	else:
		queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		egress()


func egress():
	queue_free()

func apply_world(world: PackedScene):
	var new_world = world.instance()
	$worldholder/port.add_child(new_world)


func _on_popup_hide() -> void:
	egress()
