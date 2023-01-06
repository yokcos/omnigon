extends Node
class_name StateMachine


export (NodePath) var animator_path = ""
onready var animator: AnimationPlayer = get_node(animator_path)
var enabled: bool = true setget set_enabled

onready var father: Node = get_parent()

var current_state: State = null setget set_state
var state_name: String = ""
var states = {}


signal state_changed
signal animation_finished


func _ready() -> void:
	if animator:
		animator.connect("animation_finished", self, "_on_animation_finished")
	
	register_states()
	
	enter_default_state()


func enter_default_state():
	if states.size() > 0:
		set_state( get_children()[0] )
	else:
		print("FSM Error: No states in FSM of %s" % get_parent().name)
		get_tree().quit()

func register_states():
	for i in get_children():
		if !states.has(i.name):
			states[i.name] = i
		else:
			print("FSM Error: Duplicate state: %s" % i.name)
			get_tree().quit()
		
		i.father = father


func set_state_string(what: String):
	if states.has(what):
		set_state(states[what])
	elif what == "":
		set_state(null)
	else:
		print("FSM Error: Trying to enter nonexistent state |%s|" % what)
		print_stack()
		get_tree().quit()

func set_state(what: State):
	if animator:
		if animator.has_animation(what.animation):
			animator.play(what.animation)
	
	if current_state != null:
		current_state._exit()
	
	emit_signal("state_changed", current_state, what)
	
	current_state = what
	
	if what != null:
		state_name = what.name
		what._enter()
	else:
		state_name = ""

func set_enabled(what: bool):
	if enabled != what:
		if what:
			enter_default_state()
		else:
			set_state(null)
	
	enabled = what



func _on_animation_finished(which: String):
	if states.has( current_state.auto_proceed ):
		set_state_string( current_state.auto_proceed )
	
	emit_signal("animation_finished")
