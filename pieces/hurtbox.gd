extends Area2D


# TODO: At some point add the ability to have the same hurtbox
# deal damage to the same entity every X number of seconds


var overlapping_bodies: Array = []
var hit_bodies: Dictionary = {}
var source: Being = null

export (Array, int) var target_teams = [0]
export (float) var damage = 1
export (float) var hit_rate = 0 # 0 = things cannot be hit again until manual reset
export (Vector2) var knockback = Vector2()
export (float) var radial_knockback = 0
export (bool) var active = false


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
	identify_source()

func _process(delta: float) -> void:
	if active:
		deal_damage()
	
	if hit_rate > 0:
		decay_hits(delta)


func identify_source():
	var vp: Viewport = get_viewport()
	var target: Node = self
	
	while target != vp:
		target = target.get_parent()
		if target is Being:
			source = target
			break

func deal_damage():
	for body in overlapping_bodies:
		if body is Entity:
			if target_teams.has(body.team) and !hit_bodies.has(body):
				hit_enemy(body)

func hit_enemy(what: Being):
	var trans = global_transform
	var kb_multiplicator: Vector2 = Vector2()
	kb_multiplicator.x = trans.x.x
	kb_multiplicator.y = trans.y.y
	
	var relative: Vector2 = what.global_position - global_position
	relative = relative.normalized()
	
	var actual_damage = what.take_damage(damage, source)
	if actual_damage > 0:
		what.take_knockback(knockback * kb_multiplicator)
		what.take_knockback(radial_knockback * relative)
	hit_bodies[what] = hit_rate

func decay_hits(delta: float):
	var keys = hit_bodies.keys()
	for i in keys:
		hit_bodies[i] -= delta
		if hit_bodies[i] <= 0:
			hit_bodies.erase(i)

func activate():
	reset()
	active = true

func pulse(duration: float = 0.1):
	activate()
	$deactivator.start(duration)

func reset():
	clear_hits()

func clear_hits():
	hit_bodies = {}


func _on_body_entered(what):
	if !overlapping_bodies.has(what) and what is Entity:
		overlapping_bodies.append(what)

func _on_body_exited(what):
	if overlapping_bodies.has(what):
		overlapping_bodies.erase(what)

func _on_deactivator_timeout() -> void:
	active = false
