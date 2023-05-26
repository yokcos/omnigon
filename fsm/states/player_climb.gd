extends State


var exit_state: String = "normal"

export (String) var ascend_animation = "climb_up"
export (String) var descend_animation = "climb_down"

var ladder: Area2D = null
var prev_gravity: float = 0
var climb_speed: float = 150
var vertical_margin: float = -8
var extra_margin: float = 8
var lean: float = 0
var lean_speed: float = 24
var max_lean: float = 8


func _enter():
	prev_gravity = father.gravity
	father.gravity = 0
	lean = 0
	ladder.add_exception(father)
	._enter()

func _exit():
	father.gravity = prev_gravity
	if is_instance_valid(ladder):
		ladder.remove_exception(father)
	._exit()

func _step(delta: float):
	._step(delta)
	
	if !ladder or !is_instance_valid(ladder):
		set_state(exit_state)
	else:
		var descendation: float = 0
		
		if Input.is_action_pressed("move_up"):
			descendation -= 1
		if Input.is_action_pressed("move_down"):
			descendation += 1
		
		var leaning: bool = false
		if Input.is_action_pressed("move_left"):
			leaning = true
			lean -= lean_speed * delta * 2
		if Input.is_action_pressed("move_right"):
			leaning = true
			lean += lean_speed * delta * 2
		lean = lerp(lean, 0, 0.3*delta if leaning else 4*delta)
		lean = clamp(lean, -max_lean, max_lean)
		
		if descendation == 0 and abs(lean) >= max_lean - 0.01:
			set_state(exit_state)
			father.air_time = 0
		
		father.velocity.y = descendation * climb_speed
		father.global_position.x = ladder.global_position.x + lean
		
		limit_height()
		do_animation()

func _handle_input(event: InputEvent) -> void:
	._handle_input(event)
	
	if event.is_action_pressed("jump"):
		set_state(exit_state)
		father.jump(0.75)


func limit_height():
	var laddertop: float = ladder.global_position.y - ladder.spacing/2
	var upper_margin: float = 26
	var upper_limit = laddertop - vertical_margin - upper_margin
	var lower_limit = laddertop + ladder.spacing * ladder.length + vertical_margin
	var current_pos = father.global_position.y
	
	if current_pos < upper_limit and !PlayerStats.check_upgrade("endless_climbing"):
		father.land()
		set_state("normal")
	if current_pos > lower_limit: father.velocity.y = min(father.velocity.y, 0)
	
	if father.velocity.y >= 0:
		if current_pos < upper_limit - extra_margin: father.velocity.y = max(father.velocity.y,  climb_speed * 0.5)
	if current_pos > lower_limit + extra_margin: father.velocity.y = min(father.velocity.y, -climb_speed * 0.5)

func do_animation():
	var animator: AnimationPlayer = get_animator()
	
	if animator:
		if abs(father.velocity.y) < 10:
			animator.play(animation)
		elif father.velocity.y < 0:
			animator.play(ascend_animation)
		else:
			animator.play(descend_animation)


func _on_damage_taken(what: float) -> void:
	if active:
		set_state("stunned")
