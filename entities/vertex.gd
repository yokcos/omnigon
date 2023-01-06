extends RigidBody2D


var value: float = 1
var can_be_collected: bool = false

var tex_fx = preload("res://fx/coin_collect.png")
var source: Node2D = null

var recent_vertices: float = 0


signal collected


func _ready() -> void:
	connect("collected", PlayerStats, "_on_vertex_collected")
	connect("body_entered", self, "_on_body_entered")
	
	add_to_group("vertices")

func _process(delta: float) -> void:
	recent_vertices = lerp(recent_vertices, 0, delta)


func activate():
	can_be_collected = true
	$entity_detector.check()


func _on_entity_detector_activated() -> void:
	if can_be_collected:
		can_be_collected = false
		emit_signal("collected", value)
		Game.deploy_fx(tex_fx, global_position, 4)
		var new_sfx: SFX = GlobalSound.play_random_sfx(GlobalSound.sfx_vertex_grab)
		var extra_pitch = 0.2 * recent_vertices
		new_sfx.randomise_pitch(0.8 + extra_pitch, 1.2 + extra_pitch)
		
		if source:
			WorldSaver.add_data(source.spawn_position, value)
		
		for i in get_tree().get_nodes_in_group("vertices"):
			i.recent_vertices += 1
		
		queue_free()

func _on_body_entered(what: Node):
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_vertex_hit, global_position)
	new_sfx.randomise_pitch(0.8, 1.2)
