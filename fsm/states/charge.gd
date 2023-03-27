extends State


export (String) var recover_animation = ""
export (Vector2) var target_velocity = Vector2()
export (float) var acceleration = 0

var recovering: bool = false
var next_state: String = ""
var animator: AnimationPlayer = null

signal activated

func _enter() -> void:
	._enter()
	
	father.can_flip = false
	
	if !animator:
		animator = get_animator()
		if !animator:
			print("Charge state error: No animator")
		get_parent().connect("animation_finished", self, "_on_animation_finished")
	
	reset()

func _exit():
	._exit()
	
	father.reset_flippability()

func _step(delta: float):
	._step(delta)
	
	if acceleration > 0:
		var relative_velocity = target_velocity - father.velocity
		father.velocity.x += sign(relative_velocity.x) * delta * acceleration


func reset():
	recovering = false
	
	if animator.has_animation(recover_animation):
		next_state = auto_proceed
		auto_proceed = ""

func activate():
	animator.play(recover_animation)
	auto_proceed = next_state
	emit_signal("activated")
	recovering = true


func _on_animation_finished():
	if !recovering and animator.has_animation(recover_animation):
		activate()
