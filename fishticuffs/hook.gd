extends Being


var reload_duration: float = 0.75
var attack_duration: float = 0.25
var rtime: float = 0
var max_speed: float = 100

const obj_chain = preload("res://fishticuffs/chain.tscn")

signal died


func _ready() -> void:
	acceleration = 1000
	gravity = 0
	can_bounce = false
	can_be_bounced = false
	
	obj_part_hit = preload("res://fishticuffs/decor/part_fish_hit.tscn")
	
	deploy_chain()

func _process(delta: float) -> void:
	rtime -= delta
	$flippable/sprite.frame = 0
	if rtime > reload_duration - attack_duration:
		$flippable/sprite.frame = 2
	elif rtime >= 0:
		$flippable/sprite.frame = 1
		if $hurtbox.active:
			$hurtbox.active = false
	
	if GlobalSound.ear:
		GlobalSound.ear.position = global_position

func _physics_process(delta: float) -> void:
	tractutate(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") or event.is_action_pressed("jump"):
		attack()


func take_damage(what: float, from: Being = null):
	var dmg = .take_damage(what, from)
	
	GlobalSound.play_random_sfx_2d( GlobalSound.sfx_DT, global_position )
	return dmg

func die():
	emit_signal("died")
	
	.die()

func tractutate(delta: float):
	var traction: Vector2 = Vector2()
	
	if Input.is_action_pressed("move_up"):
		traction.y -= 1
	if Input.is_action_pressed("move_down"):
		traction.y += 1
	if Input.is_action_pressed("move_left"):
		traction.x -= 1
	if Input.is_action_pressed("move_right"):
		traction.x += 1
	
	traction = traction.normalized()
	velocity += traction * acceleration * delta

func frictutate(delta: float):
	if friction <= 0:
		return false
	
	velocity -= velocity * friction * delta

func deploy_chain():
	var prev_chain = null
	for i in range(32):
		var new_chain = obj_chain.instance()
		if !prev_chain:
			new_chain.next = self
		else:
			new_chain.next = prev_chain
		prev_chain = new_chain
		new_chain.position = position - Vector2(0, i*20)
		get_parent().call_deferred("add_child", new_chain)

func attack():
	if rtime <= 0:
		velocity += Vector2(0, 350)
		rtime = reload_duration
		$hurtbox.active = true
		
		GlobalSound.play_random_sfx_2d( GlobalSound.sfx_fc_hook_strike, global_position )
