extends Enemy


var has_target: bool = false
var targets: Array = []
var obj_pestilent: PackedScene = load("res://entities/enemies/pestilent.tscn")
export (bool) var immediate_activation = false

const obj_bullet: PackedScene = preload("res://projectiles/bullet.tscn")
const tex_apparate: Texture = preload("res://fx/apparition_apparate.png")


func _ready() -> void:
	saving_enabled = false
	if immediate_activation:
		activate()
	
	set_collision_mask_bit(2, false)

func _process(delta: float) -> void:
	if has_target:
		var behind_target: bool = global_position.x < targets[0].global_position.x
		if targets[0].flipped == behind_target:
			$fsm/patrol.set_state("hide")
		else:
			if $fsm/hide.set_state("patrol"):
				$fsm/patrol.attack_time = rand_range(0.5, 1.5)


func activate():
	$fsm/invisible.set_state("patrol")
	
	if !immediate_activation:
		GlobalSound.play_random_sfx_2d(GlobalSound.sfx_blap, global_position)
		Game.deploy_fx(tex_apparate, global_position, 8)

func get_loaded(data):
	if data:
		.get_loaded(data)
	
	for ladder in get_tree().get_nodes_in_group("ladders"):
		add_collision_exception_with(ladder.get_node("top"))

func get_shifted():
	var pestilents = []
	
	for i in range(4):
		var new_pestilent = obj_pestilent.instance()
		var dir = Vector2(1, 0).rotated( PI/4 + i*PI/2 )
		new_pestilent.velocity = dir * 40
		Game.deploy_instance(new_pestilent, global_position + dir*8)
		pestilents.append(new_pestilent)
	
	for i in pestilents:
		i.grouped_pestilents = pestilents
	
	queue_free()


func _on_attacc_activated() -> void:
	var new_bullet = obj_bullet.instance()
	new_bullet.get_node("wall_detector/hitbox").disabled = true
	var dir: Vector2
	if has_target:
		dir = (targets[0].global_position - $flippable/barrel.global_position).normalized()
	else:
		dir = Vector2(flip_int, 0)
	new_bullet.velocity = dir * 200
	Game.deploy_instance(new_bullet, $flippable/barrel.global_position)
	
	var new_sfx: SFX2D = GlobalSound.play_random_sfx_2d(GlobalSound.sfx_fart, global_position)
	new_sfx.relative_volume = 0.9
	new_sfx.randomise_pitch(0.4, 0.6)

func _on_player_detector_updated(what: Array) -> void:
	has_target = what.size() > 0
	targets = what
	if has_target:
		$fsm/patrol.target = what[0]
	else:
		$fsm/patrol.target = null

func _on_invisible_entered() -> void:
	$hitbox.disabled = true
	hide()

func _on_invisible_exited() -> void:
	$hitbox.disabled = false
	show()
